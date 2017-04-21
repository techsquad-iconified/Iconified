//
//  PoliceMapViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 21/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit
import MapKit

class PoliceMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    
    //users location
    var latitude: Double?
    var longitude: Double?
    
    var selectedPolice: Hospital
    
    //Array of place details retrieved from the user
    var policeArray: NSMutableArray
    
    // declaring the global variable for location manager
    let locationManager: CLLocationManager
    
    // creating a view to display a progress spinner while data is being loaded from the server
    var progressView = UIView()
    
    //Initialiser
    required init?(coder aDecoder: NSCoder) {
        self.policeArray = NSMutableArray()
        self.selectedPolice = Hospital()
        self.latitude = nil
        self.longitude = nil
        self.locationManager = CLLocationManager()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        // setting up the progress view
        setProgressView()
        self.view.addSubview(self.progressView)
        self.mapView.delegate = self
        
        //call method to get users current location
        self.getUsersCurrentLocation()
        
        //Method to create the API call from the server
        DispatchQueue.main.async(){
            //self.downloadLocationData()
            self.downloadLocationDataFromServer()
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        self.latitude = (locationManager.location?.coordinate.latitude)!
        self.longitude = (locationManager.location?.coordinate.longitude)!
    }
    
    /*
     Function adds annotations on the map for the selected category
     */
    func addLocationAnnotations()
    {
        //remove all annotations already existing
        //  let allAnnotations = self.mapView.annotations
        //self.mapView.removeAnnotations(allAnnotations)
        
        if(self.policeArray.count != 0 )
        {
            for case let hospital as Hospital in policeArray
            {
                if (hospital.lat != nil)     // if it has a previous latitude
                {
                    let loc = CLLocationCoordinate2D(latitude: Double((hospital.lat)!) , longitude: Double((hospital.lng)!))
                    let center = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                    let point = EmergencyAnnotation(coordinate: loc)
                    
                    point.image = hospital.firstPhoto
                    
                    point.name = hospital.name
                    point.type = hospital.type
                    point.hospital = hospital
                    mapView.addAnnotation(point)
                    
                    let area = MKCoordinateRegion(center: center , span: MKCoordinateSpan(latitudeDelta: 0.009,longitudeDelta: 0.009))
                    mapView.setRegion(area, animated: true)
                    mapView.showAnnotations(mapView.annotations, animated: true)
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
        message.text = "Finding Police stations..."
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
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }
        else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "Police Station")
        
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
        let emergencyAnnotation = view.annotation as! EmergencyAnnotation
        let views = Bundle.main.loadNibNamed("EmergencyCalloutView", owner: nil, options: nil)
        
        //get the callout view
        let calloutView = views?[0] as! EmergencyCallout
        
        //Add name to view
        calloutView.nameLabel.text = emergencyAnnotation.name
        if(emergencyAnnotation.image.size == CGSize(width: 0.0, height: 0.0))
        {
            calloutView.imageView.image = UIImage(named: "Police Station")
        }
        else
        {
            calloutView.imageView.image = emergencyAnnotation.image
        }
        self.selectedPolice = emergencyAnnotation.hospital
        
        
        //Adding gesture recognition for details icon
        let tapGestureRecogniserForDetailIcon = UITapGestureRecognizer(target: self, action:#selector(HospitalMapViewController.detailsSelected))
        calloutView.detailsIcon.isUserInteractionEnabled = true
        calloutView.detailsIcon.addGestureRecognizer(tapGestureRecogniserForDetailIcon)
        
        //Adding gesture recognition for image icon
        let tapGestureRecogniserForImageIcon = UITapGestureRecognizer(target: self, action:#selector(HospitalMapViewController.detailsSelected))
        calloutView.imageView.isUserInteractionEnabled = true
        calloutView.imageView.addGestureRecognizer(tapGestureRecogniserForImageIcon)
        
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
    
    func detailsSelected()
    {
        performSegue(withIdentifier: "PoliceDetailSegue", sender: nil)
    }

    //Function makes a API call to the server to fetch the required place details
    func downloadLocationDataFromServer()
    {
        var url: URL
        url = URL(string:"http://23.83.248.221/test?searchType=police&myLocation=\(self.latitude!),\(self.longitude!)")!
        //http://23.83.248.221/test?searchType=police&myLocation=-33.8670,151.1957
        //http://23.83.248.221/test?searchType=police&myLocation=-37.877009,145.044267
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
        //Local variables to store place details
        var hospitalLat: Double = 0.0
        var hospitalLng: Double = 0.0
        var name: String = "unknown"
        var type: String = "unavailable"
        var address: String = "unknown"
        var firstOneDone : Bool = false
        
        do{
            let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            
            print("Json Data is \(jsonData)")
            for eachItem in jsonData
            {
                firstOneDone = false    // Flag to get the forst image in the photo list
                let hospital = eachItem as! NSDictionary
                if let location = hospital["location"] as? NSDictionary
                {
                    //get location details of the place
                    hospitalLat = location.object(forKey: "lat")! as! Double
                    hospitalLng = location.object(forKey: "lng")! as! Double
                }
                //get address, name, open status and id of the place
                address = hospital.object(forKey: "address") as! String
                name = hospital.object(forKey: "name") as! String
                type = "Hospital"
                //create a object of place for the details obtained
                let newHospital = Hospital(name: name, address: address, type: type, lat: hospitalLat, lng: hospitalLng)
                
                //addtional details for the place
                newHospital.phoneNumber = hospital.object(forKey: "numbers") as? String
                newHospital.priceLevel = hospital.object(forKey: "price_level") as? Int
                newHospital.rating = hospital.object(forKey: "rating") as? Float
                newHospital.website = hospital.object(forKey: "website") as? String
                newHospital.url = hospital.object(forKey: "url") as? String
                
                //If photo exists get the first photo and an array of photo reference string.
                if let photos = hospital["photos"] as? NSArray
                {
                    for photo in photos
                    {
                        let eachPhoto = photo as? NSDictionary
                        let reference: String = (eachPhoto?.object(forKey: "photo_reference") as? String)!
                        print("reference is \(reference)")
                        newHospital.photoReference.append(reference)
                        if(firstOneDone == false)
                        {
                            // retrieve images for each place.
                            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8")!
                            print(url)
                            let data = NSData(contentsOf:url as URL)
                            if(data != nil)
                            {
                                print("Photo was not nil")
                                newHospital.firstPhoto = UIImage(data:data! as Data)!
                                // newPlace.photos.append(UIImage(data:data! as Data)!)
                            }
                        }
                        firstOneDone = true
                    }
                }
                //Add the place to the placeArray
                self.policeArray.add(newHospital)
                
                //printing the details in console for testing purpose
                print("name is \(newHospital.name)")
                print("type is \(newHospital.type)")
                print("address is \(newHospital.address)")
                print("latitude is \(newHospital.lat)")
                print("price level is\(newHospital.priceLevel)")
                print("rating is \(newHospital.rating)")
                print("Webisite is \(newHospital.website)")
                print("url is \(newHospital.url)")
                print("no of photo reference is \(newHospital.photoReference.count)")
            }
            
        }
        catch{
            print("JSON Serialization error")
        }
        print("while parsing count is \(self.policeArray.count)")
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PoliceDetailSegue")
        {
            let destinationDetailVC: EmergenyDetailViewController = segue.destination as! EmergenyDetailViewController
            destinationDetailVC.selectedPlace = self.selectedPolice
            destinationDetailVC.gpSelected = false
        }
        
    }
    
    
}
