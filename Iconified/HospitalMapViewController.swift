//
//  HospitalMapViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 20/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit
import MapKit

class HospitalMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, languageDelegate {

    @IBOutlet var mapView: MKMapView!
    
    //users location
    var latitude: Double?
    var longitude: Double?
    
    var selectedHospital: Hospital
    
    //Array of place details retrieved from the user
    var hospitalArray: NSMutableArray
    
    // declaring the global variable for location manager
    let locationManager: CLLocationManager
    
    // creating a view to display a progress spinner while data is being loaded from the server
    var progressView = UIView()
    
    let languageButton = UIButton.init(type: .custom)
    var selectedLanguage: String?
    
    //Initialiser
    required init?(coder aDecoder: NSCoder) {
        self.hospitalArray = NSMutableArray()
        self.selectedHospital = Hospital()
        self.latitude = nil
        self.longitude = nil
        self.selectedLanguage = "Australia"
        self.locationManager = CLLocationManager()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        // setting up the progress view
        setProgressView()
        self.view.addSubview(self.progressView)
        self.mapView.delegate = self
        
        languageButton.setImage(UIImage.init(named: "Australia"), for: UIControlState.normal)
        languageButton.addTarget(self, action:#selector(HospitalMapViewController.languageSelector), for: UIControlEvents.touchUpInside)
        languageButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: languageButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        
        //call method to get users current location
        self.getUsersCurrentLocation()
        
        //Method to create the API call from the server
        DispatchQueue.main.async(){
            //self.downloadLocationData()
            self.downloadLocationDataFromServerOpendata()
        }

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func languageSelector()
    {
        performSegue(withIdentifier: "languageSelectorSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateURL() -> String
    {
        switch(self.selectedLanguage!)
        {
        case "Arab": return "http://23.83.248.221/emergency?searchType=gpl&language=Arabic"
        case "China": return "http://23.83.248.221/emergency?searchType=gpl&language=Chinese"
        case "India": return "http://23.83.248.221/emergency?searchType=gpl&language=Hindi"
        case "Italy": return "http://23.83.248.221/emergency?searchType=gpl&language=Italian"
        case "France": return "http://23.83.248.221/emergency?searchType=gpl&language=French"
        case "Greece": return "http://23.83.248.221/emergency?searchType=gpl&language=Greek"
        case "Germany": return "http://23.83.248.221/emergency?searchType=gpl&language=German"
        case "Vietnam": return "http://23.83.248.221/emergency?searchType=gpl&language=Vietnamese"
        default: return "http://23.83.248.221/emergency?searchType=gpl&language=Australia"
        }
    }

    func apiCallToServerForGPWithLanguage()
    {
        
        if(self.selectedLanguage! == "Australia")
        {
            self.downloadLocationDataFromServerOpendata()
        }
        else
        {
            var url: URL
            url = URL(string: self.generateURL())!
            
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
                        self.parseJSONForGPWithLanguage(articleJSON: data! as NSData)
                    }
                    
                    DispatchQueue.main.async(){
                        self.addLocationAnnotations()
                    }
                }
            })
            
            task.resume()
        }
    }
    
    func languageSelected(language: String) {
        
        print("Delegate method called")
        // setting up the progress view
        setProgressView()
        self.view.addSubview(self.progressView)
        
        languageButton.setImage(UIImage.init(named: language), for: UIControlState.normal)
        self.selectedLanguage = language
        self.hospitalArray = NSMutableArray()
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.apiCallToServerForGPWithLanguage()
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let sourceController = segue.source as! LanguageTableViewController
        // self.title = sourceController.currentItem
    }
    
    func parseJSONForGPWithLanguage(articleJSON:NSData)
    {
        //Local variables to store place details
        var hospitalLat: Double = 0.0
        var hospitalLng: Double = 0.0
        var name: String = "unknown"
        var type: String = "unavailable"
        var address: String = "unknown"
        
        
        do{
            let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            
            //print("Json Data is \(jsonData)")
            
            for eachPlace in jsonData
            {
                let hospital = eachPlace as! NSDictionary
                name = hospital.object(forKey: "name") as! String
                type = "General Practitioner"
                address = hospital.object(forKey: "address") as! String
                let geometry = hospital.object(forKey: "geometry") as! NSDictionary
                let coordinates = geometry.object(forKey: "coordinates") as! NSArray
                hospitalLng = coordinates[0] as! Double
                hospitalLat = coordinates[1] as! Double
                
                let newHospital = Hospital(name: name, address: address, type: type, lat: hospitalLat, lng: hospitalLng)
                
                newHospital.email = hospital.object(forKey: "email") as! String
                newHospital.languageSpoken = hospital.object(forKey: "language") as! String
                newHospital.phoneNumber = hospital.object(forKey: "phone") as! String
                newHospital.url = "https://www.google.co.in/maps/dir//\(hospitalLat),\(hospitalLng)"
                
                self.hospitalArray.add(newHospital)
                
                //printing the details in console for testing purpose
                print("PLace name is \(newHospital.name)")
                print("address is \(newHospital.address)")
                print("type is \(newHospital.type)")
                print("longitude is \(newHospital.lng)")
                print("latitude is \(newHospital.lat)")
                
            }
        }
        catch{
            print("JSON Serialization error")
        }
        // print("while parsing count is \(self.placeArray.count)")
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
        
        if(self.hospitalArray.count != 0 )
        {
            for case let hospital as Hospital in hospitalArray
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
        if(self.selectedLanguage != "Australia")
        {
        let alert = UIAlertController(title: "General Practitioners Only", message: "Only General Practitions are available for the language selected.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
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
        message.text = "Finding hospitals..."
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

        let res = annotation as! EmergencyAnnotation
        if(res.type == "General Practitioner")
        {
            annotationView?.image = UIImage(named: "doctor small")
        }
        else
        {
            annotationView?.image = UIImage(named: "Hospital Building")
        }
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
        calloutView.typelabel.text = emergencyAnnotation.type
        if(emergencyAnnotation.type == "General Practitioner")
        {
            calloutView.imageView.image = UIImage(named: "doctor")
        }
        else if(emergencyAnnotation.image.size == CGSize(width: 0.0, height: 0.0))
        {
            calloutView.imageView.image = UIImage(named: "Hospital Building")
        }
        else
        {
            calloutView.imageView.image = emergencyAnnotation.image
        }
        self.selectedHospital = emergencyAnnotation.hospital
        
        
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
    
    //Method called when details icon is selected
    func detailsSelected()
    {
        performSegue(withIdentifier: "HospitalDetailSegue", sender: nil)
    }
    
    //Function makes a API call to the server to fetch the hospital details
    func downloadLocationDataFromServerOpendata()
    {
        var url: URL
        url = URL(string:"http://23.83.248.221/emergency?searchType=gp&myLocation=\(self.longitude!),\(self.latitude!)")!

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
                    self.parseServerOpenDataJSON(articleJSON: data! as NSData)
                }
                
                DispatchQueue.main.async(){
                    self.downloadLocationDataFromServer()
                }
            }
        })
        
        task.resume()
    }

    //Method to parse the JSON response from the server
    func parseServerOpenDataJSON(articleJSON:NSData)
    {
        //Local variables to store place details
        var hospitalLat: Double = 0.0
        var hospitalLng: Double = 0.0
        var name: String = "unknown"
        var type: String = "unavailable"
        var address: String = "unknown"
        
        
        do{
            let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            
            //print("Json Data is \(jsonData)")
            
            for eachPlace in jsonData
            {
                let hospital = eachPlace as! NSDictionary
                name = hospital.object(forKey: "name") as! String
                type = "General Practitioner"
                address = hospital.object(forKey: "address") as! String
                let geometry = hospital.object(forKey: "geometry") as! NSDictionary
                let coordinates = geometry.object(forKey: "coordinates") as! NSArray
                hospitalLng = coordinates[0] as! Double
                hospitalLat = coordinates[1] as! Double
                
                let newHospital = Hospital(name: name, address: address, type: type, lat: hospitalLat, lng: hospitalLng)
                
                newHospital.email = hospital.object(forKey: "email") as! String
                newHospital.languageSpoken = hospital.object(forKey: "language") as! String
                newHospital.phoneNumber = hospital.object(forKey: "phone") as! String
                newHospital.url = "https://www.google.co.in/maps/dir//\(hospitalLat),\(hospitalLng)"
                
                self.hospitalArray.add(newHospital)
                
                //printing the details in console for testing purpose
                print("PLace name is \(newHospital.name)")
                print("address is \(newHospital.address)")
                print("type is \(newHospital.type)")
                print("longitude is \(newHospital.lng)")
                print("latitude is \(newHospital.lat)")

            }
        }
        catch{
            print("JSON Serialization error")
        }
    }
    
    //Function makes a API call to the server to fetch the required place details
    func downloadLocationDataFromServer()
    {
        var url: URL
        url = URL(string:"http://23.83.248.221/test?searchType=hospital&myLocation=\(self.latitude!),\(self.longitude!)")!
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
                DispatchQueue.main.async(){  //Parse the data received
                    self.parseServerJSON(articleJSON: data! as NSData)
                }
                DispatchQueue.main.async(){    //Call to Add annotations method
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
                            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=AIzaSyAMW8Z_cdUbbVMMviRfe845JBj7xbKhRp4")!
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
                self.hospitalArray.add(newHospital)
                
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
        print("while parsing count is \(self.hospitalArray.count)")
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if a particular GP or hospital is selected
        if(segue.identifier == "HospitalDetailSegue")
        {
            let destinationDetailVC: EmergenyDetailViewController = segue.destination as! EmergenyDetailViewController
            destinationDetailVC.selectedPlace = self.selectedHospital
            if(self.selectedHospital.type == "General Practitioner")
            {
                destinationDetailVC.gpSelected = true
            }
            else
            {
                destinationDetailVC.gpSelected = false
            }
        }
        //If the language selector is selected
        if(segue.identifier == "languageSelectorSegue")
        {
            let destinationLanguageVC: LanguageTableViewController = segue.destination as! LanguageTableViewController
            destinationLanguageVC.delegate = self
        }
    }
    

}
