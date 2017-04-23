//
//  PtvMapViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 10/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit
import MapKit
/*
 PtvMapViewController is a view comtroller that displays a map view
 The map view displays the stops around users current location
 */
class PtvMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {

    //UI Controls
    @IBOutlet var ptvMapView: MKMapView!
    //users location
    var latitude: Double?
    var longitude: Double?
    // declaring the global variable for location manager
    let locationManager: CLLocationManager
    var ptvUrl: String?
    //Array of place details retrieved from the user
    var stopsArray: NSMutableArray
    // creating a view to display a progress spinner while data is being loaded from the server
    var progressView = UIView()

    //Initialiser
    required init?(coder aDecoder: NSCoder) {
        self.latitude = nil
        self.longitude = nil
        self.stopsArray = NSMutableArray()
        self.locationManager = CLLocationManager()
        super.init(coder: aDecoder)
    }
    //method called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ptvMapView.delegate = self
        
        // setting up the progress view
        setProgressView()
        self.view.addSubview(self.progressView)
        
        //call method to get users current location
        self.getUsersCurrentLocation()
        
        //Method to create the API call from the server
        DispatchQueue.main.async(){
            self.getSignatureFromServer()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.portrait)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function to get users current location
    func getUsersCurrentLocation()
    {
        /*
         All Location Manager functions have been implemented based on the tutorials provided by Matthew Kairys.
         Credits: Tutorials by Matthew Kairys
         */
        // setting up location manager
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        // start recording the users location
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            print("in if")
        }
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        print("Users Current location \(self.longitude) and \(self.longitude)")
        self.latitude = (locationManager.location?.coordinate.latitude)!
        self.longitude = (locationManager.location?.coordinate.longitude)!
        print("Lat and lng of the user is \(self.latitude) and \(self.longitude)")
    }
    //Method getting PTV API signature from server
    func getSignatureFromServer()
    {
        var url: URL
        url = URL(string: "http://23.83.248.221/testpy?myLocation=\(self.latitude!),\(self.longitude!)")!
        print(url)
        let urlRequest = URLRequest(url: url)
        
        //setting up session
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if (error != nil)    //checking if the any error message received during connection
            {
                print("Error \(error)")
                let alert = UIAlertController(title: "Sorry! Server Failed!", message: "Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                DispatchQueue.main.async()
                {
                    do{
                        let jsonData = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        for urlData in jsonData
                        {
                            self.ptvUrl = urlData as! String
                            print("Json Data is \(urlData)")
                        }
                    }
                    catch{
                        print("JSON Serialization error")
                    }
                
                }
                DispatchQueue.main.async(){
                    self.downloadLocationDataFromServer()
                }
            }
        })
        
        task.resume()
    }
    
    
    //Function makes a API call to the server to fetch the required place details
    func downloadLocationDataFromServer()
    {
        print("Lat and lng of the user is \(self.latitude!) and \(self.longitude!)")
        var url: URL
        url = URL(string: self.ptvUrl!)!
        print(url)
        let urlRequest = URLRequest(url: url)
        
        //setting up session
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if (error != nil)    //checking if the any error message received during connection
            {
                print("Error \(error)")
                let alert = UIAlertController(title: "Sorry! Server Failed!", message: "Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                DispatchQueue.main.async(){
                    self.parseServerJSON(articleJSON: data! as NSData)
                }
                
                // Do any additional setup after loading the view.
                DispatchQueue.main.async(){
                  self.addLocationAnnotations()
                }
            }
        })
        
        task.resume()
    }
    
    //Method to parse the JSON response from the server
    func parseServerJSON(articleJSON:NSData)
    {
        //Local variables to store stop details
        var routeType: Int
        var stopDistance: Double
        var stopId: Int
        var stopLatitude: Double
        var stopLongitude: Double
        var stopName: String
        
        
        do{
            let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
            let dataArray = jsonData.object(forKey: "stops") as! NSArray
            
            for jdata in dataArray
            {
                //print("Stop Data is \(jdata)")
                
                let stop = jdata as! NSDictionary
                
                routeType = (stop.object(forKey: "route_type") as? Int)!
                stopDistance = (stop.object(forKey: "stop_distance") as? Double)!
                stopId = (stop.object(forKey: "stop_id") as? Int)!
                stopLatitude = (stop.object(forKey: "stop_latitude") as? Double)!
                stopLongitude = (stop.object(forKey: "stop_longitude") as? Double)!
                stopName = (stop.object(forKey: "stop_name") as? String)!
                
                let newPtvStop = PtvStops(routeType: routeType, stopDistance: stopDistance, stopId: stopId, stopLatitude: stopLatitude, stopLongitude: stopLongitude, stopName: stopName)
                
                //Add the place to the placeArray
                self.stopsArray.add(newPtvStop)
                
                //printing the details in console for testing purpose
                print("RouteType is \(newPtvStop.routeType)")
                print("stop distance is \(newPtvStop.stopDistance)")
                print("stopId is \(newPtvStop.stopId)")
                print("stopLatitude is \(newPtvStop.stopLatitude))")
                print("stopLongitude is \(newPtvStop.stopLongitude))")
                print("stopName is\(newPtvStop.stopName))")
            }
        }
        catch{
            print("JSON Serialization error")
        }
    }
    
    /*
     Function adds annotations on the map for the selected category
     */
    func addLocationAnnotations()
    {
        //remove all annotations already existing
        let allAnnotations = self.ptvMapView.annotations
        self.ptvMapView.removeAnnotations(allAnnotations)
        
        if(self.stopsArray.count != 0 )
        {
            for case let stop as PtvStops in stopsArray
            {
                if (stop.stopLatitude != nil)     // if it has a previous latitude
                {
                    let loc = CLLocationCoordinate2D(latitude: Double((stop.stopLatitude)!) , longitude: Double((stop.stopLongitude)!))
                    let center = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                    let point = StopsAnnotation(coordinate: loc)
                    point.name = stop.stopName
                    
                    if((stop.routeType)! == 0 )
                    {
                        point.image = UIImage(named: "Train")
                    }
                    else if((stop.routeType)! == 1 )
                    {
                        point.image = UIImage(named: "Tram")    //drinks annotation
                    }
                    else if((stop.routeType)! == 2 )
                    {
                        point.image = UIImage(named: "Bus")     //Restaurant annotation
                    }
                    else
                    {
                      //  point.image = UIImage(named: "Beer")
                    }
                    
                    ptvMapView.addAnnotation(point)
                    
                    let area = MKCoordinateRegion(center: center , span: MKCoordinateSpan(latitudeDelta: 0.008,longitudeDelta: 0.008))
                    ptvMapView.setRegion(area, animated: true)
                }
            }
        }
        self.stopProgressView()
        
    }
    
    /*
     Setting up the progress view that displays a spinner while the serer data is being downloaded.
     The view uses an activity indicator (a spinner) and a simple text to convey the information.
     Source: YouTube
     Tutorial: Swift - How to Create Loading Bar (Spinners)
     Author: Melih Şimşek
     URL: https://www.youtube.com/watch?v=iPTuhyU5HkI
     */
    func setProgressView()
    {
        self.progressView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        self.progressView.backgroundColor = UIColor.darkGray
        self.progressView.layer.cornerRadius = 10
        let wait = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        wait.color = UIColor.white
        //UIColor(red: 254/255, green: 218/255, blue: 2/255, alpha: 1)
        wait.hidesWhenStopped = false
        wait.startAnimating()
        
        let message = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        message.text = "Finding stops ..."
        message.textColor = UIColor.white
        
        self.progressView.addSubview(wait)
        self.progressView.addSubview(message)
        self.progressView.center = self.view.center
        self.progressView.tag = 1000
        
    }
    
    /*
     This method is invoked to remove the progress spinner from the view.
     Source: YouTube
     Tutorial: Swift - How to Create Loading Bar (Spinners)
     Author: Melih Şimşek
     URL: https://www.youtube.com/watch?v=iPTuhyU5HkI
     */
    func stopProgressView()
    {
        let subviews = self.view.subviews
        for subview in subviews
        {
            if subview.tag == 1000
            {
                subview.removeFromSuperview()
            }
        }
    }
    
    //MARK: MKMapViewDelegate
    //Method to create a view for the annotations - annotations represent the category selected
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.ptvMapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }
        else{
            annotationView?.annotation = annotation
        }
        let res = annotation as! StopsAnnotation
        annotationView?.image = res.image
        return annotationView
    }
    
    //method is called when a particular annotation is selected
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        // if users location annotation is selected
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        
        // if other anotations selected
        let stopAnnotation = view.annotation as! StopsAnnotation
        let views = Bundle.main.loadNibNamed("PtvCalloutView", owner: nil, options: nil)
        //get the callout view
        let calloutView = views?[0] as! PtvCalloutView
        //Add Image, name, open status and a details icon
        calloutView.stopName.text = stopAnnotation.name
        calloutView.stopImage.image = stopAnnotation.image
        
        calloutView.center = CGPoint(x: view.bounds.size.width / 4, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    //Method is called when annotation is deselected or clicked outside the location
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
