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
    //selcted annotation
    var selectedAnnotation: EmergencyAnnotation
    
    let languageButton = UIButton.init(type: .custom)
    var selectedLanguage: String?
    
    //Images used to represent the rating of the place
    let fullStarImage:  UIImage = UIImage(named: "Star Full")!
    let halfStarImage:  UIImage = UIImage(named: "Star Half")!
    let emptyStarImage: UIImage = UIImage(named: "Star Grey")!
    
    //Initialiser
    required init?(coder aDecoder: NSCoder) {
        self.hospitalArray = NSMutableArray()
        self.selectedHospital = Hospital()
        self.latitude = nil
        self.longitude = nil
        self.selectedLanguage = "Australia"
        self.selectedAnnotation = EmergencyAnnotation()
        self.locationManager = CLLocationManager()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        // setting up the progress view
        setProgressView(type: "Hospital")
        self.view.addSubview(self.progressView)
        self.mapView.delegate = self
        
        languageButton.setImage(UIImage.init(named: "Australia"), for: UIControlState.normal)
        self.selectedLanguage = "Australia"
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
        setProgressView(type: "GP")
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
                      point.isOpen = hospital.isOpen
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
    func setProgressView(type: String)
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
        if type == "Hospital"
        {
            message.text = "Finding hospitals..."
        }
        else
        {
            message.text = "Getting details..."
        }
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
        //let tlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        //tlabel.text = self.title
        calloutView.nameLabel.textColor = UIColor.white
        calloutView.nameLabel.numberOfLines = 3
        calloutView.nameLabel.textAlignment = NSTextAlignment.center
        calloutView.nameLabel.backgroundColor = UIColor.clear
        calloutView.nameLabel.adjustsFontSizeToFitWidth = true
       
      // calloutView.typelabel.text = emergencyAnnotation.type
        if(emergencyAnnotation.isOpen != nil)
        {
            calloutView.openLabel.text = (emergencyAnnotation.isOpen == "true") ? "Open" : "Close"
        }
        self.selectedHospital = emergencyAnnotation.hospital
        self.selectedAnnotation = emergencyAnnotation
        self.getRating(calloutView: calloutView)

        
        //Adding gesture recognition for details icon
        let tapGestureRecogniserForDetailIcon = UITapGestureRecognizer(target: self, action:#selector(HospitalMapViewController.detailsSelected))
        calloutView.detailsButton.isUserInteractionEnabled = true
        calloutView.detailsButton.addGestureRecognizer(tapGestureRecogniserForDetailIcon)
        
        //Adding gesture recognition for image icon
        let tapGestureRecogniserForImageIcon = UITapGestureRecognizer(target: self, action:#selector(HospitalMapViewController.detailsSelected))
        calloutView.nameLabel.isUserInteractionEnabled = true
        calloutView.nameLabel.addGestureRecognizer(tapGestureRecogniserForImageIcon)
        
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
        if(self.selectedAnnotation.type! == "General Practitioner")
        {
            performSegue(withIdentifier: "HospitalDetailSegue", sender: nil)
        }
        else if(self.selectedLanguage! == "Australia")
        {
            self.mapView.deselectAnnotation(self.selectedAnnotation, animated: true)
            // setting up the progress view
            setProgressView(type: "details")
            self.view.addSubview(self.progressView)
            
            //Method to create the API call from the server to fetch details
            DispatchQueue.main.async(){
                self.downloadPlaceDetailsFromServer()
            }
        }
        else
        {
            performSegue(withIdentifier: "HospitalDetailSegue", sender: nil)
        }
    }
    //Funtion displays the rating of teh place using images of stars
    func getRating(calloutView: EmergencyCallout)
    {
        if(self.selectedHospital.rating != nil)
        {
            if let ourRating = self.selectedHospital.rating
            {
                calloutView.ratingOne.image = getStarImage(starNumber: 1, forRating: ourRating)
                calloutView.ratingTwo.image = getStarImage(starNumber: 2, forRating: ourRating)
                calloutView.ratingThree.image = getStarImage(starNumber: 3, forRating: ourRating)
                calloutView.ratingFour.image = getStarImage(starNumber: 4, forRating: ourRating)
                calloutView.ratingFive.image = getStarImage(starNumber: 5, forRating: ourRating)
            }
        }
    }
    
    //funtion returns approriate star images
    func getStarImage(starNumber: Float, forRating rating: Float) -> UIImage {
        if rating >= starNumber {
            return fullStarImage
        } else if rating + 0.5 >= starNumber {
            return halfStarImage
        } else {
            return emptyStarImage
        }
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
       // url = URL(string:"http://23.83.248.221/test?searchType=hospital&myLocation=\(self.latitude!),\(self.longitude!)")!
        url = URL(string:"http://23.83.248.221/generalquery?searchType=hospital&myLocation=\(self.latitude!),\(self.longitude!)")!
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
        var placeLat: Double = 0.0
        var placeLng: Double = 0.0
        var placeId: String = "unknown"
        var placeName: String = "unknown"
        var isOpen: String = "unavailable"
        var firstOneDone : Bool = false
        
        do{
            let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            
            print("Json Data is \(jsonData)")
            for eachPlace in jsonData
            {
                firstOneDone = false    // Flag to get the forst image in the photo list
                let place = eachPlace as! NSDictionary
                if let location = place["location"] as? NSDictionary
                {
                    //get location details of the place
                    placeLat = location.object(forKey: "lat")! as! Double
                    placeLng = location.object(forKey: "lng")! as! Double
                    print("location is \(placeLat) and \(placeLng)")
                }
                //get address, name, open status and id of the place
                // placeAddress = place.object(forKey: "address") as! String
                placeName = place.object(forKey: "name") as! String
                placeId = place.object(forKey: "place_id") as! String
                isOpen = place.object(forKey: "open_now") as! String
                
                //create a object of place for the details obtained
                let newPlace = Hospital(lat: placeLat, lng: placeLng, placeId: placeId, placeName: placeName, isOpen: isOpen)
                //addtional details for the place
                newPlace.rating = place.object(forKey: "rating") as? Float
                newPlace.type = "Hospital"
                
                
                //Add the place to the placeArray
                self.hospitalArray.add(newPlace)
                
                //printing the details in console for testing purpose
                print("PLace name is \(newPlace.name)")
                print("open now is \(newPlace.isOpen)")
                print("place id is \(newPlace.placeId)")
                print("rating is \(newPlace.rating)")
            }
        }
        catch
        {
            print("JSON Serialization error")
        }
        print("while parsing count is \(self.hospitalArray.count)")
    }

    //Method to download details of the selected place from server
    func downloadPlaceDetailsFromServer()
    {
        var url: URL
        //  url = URL(string:"http://23.83.248.221/test?searchType=\(self.bankType!)&myLocation=\(self.latitude!),\(self.longitude!)")!
        url = URL(string:"http://23.83.248.221/detailedquery?placeId=\(self.selectedHospital.placeId!)")!
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
                    self.parseDetailsJSON(articleJSON: data! as NSData)
                }
            }
        })
        
        task.resume()
        
    }
    //Method to parse details of the selected place
    func parseDetailsJSON(articleJSON:NSData)
    {
        //Local variables to store place details
        var placeLat: Double = 0.0
        var placeLng: Double = 0.0
        var placeId: String = "unknown"
        var placeName: String = "unknown"
        var isOpen: String = "unavailable"
        var placeAddress: String = "unknown"
        var rating: Float = 0.0
        var firstOneDone : Bool = false
        
        do{
            let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            
            print("Json Data is \(jsonData)")
            for eachPlace in jsonData
            {
                firstOneDone = false    // Flag to get the forst image in the photo list
                let place = eachPlace as! NSDictionary
                
                //addtional details for the place
                self.selectedHospital.address = place.object(forKey: "address") as? String
                self.selectedHospital.phoneNumber = place.object(forKey: "numbers") as? String
                self.selectedHospital.priceLevel = place.object(forKey: "price_level") as? Int
                self.selectedHospital.website = place.object(forKey: "website") as? String
                self.selectedHospital.url = place.object(forKey: "url") as? String
                
                //If photo exists get the first photo and an array of photo reference string.
                if let photos = place["photos"] as? NSArray
                {
                    for photo in photos
                    {
                        let eachPhoto = photo as? NSDictionary
                        let reference: String = (eachPhoto?.object(forKey: "photo_reference") as? String)!
                        print("reference is \(reference)")
                        self.selectedHospital.photoReference.append(reference)
                        if(firstOneDone == false)
                        {
                            // retrieve images for each place.
                            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8")!
                            print(url)
                            let data = NSData(contentsOf:url as URL)
                            if(data != nil)
                            {
                                print("Photo was not nil")
                                self.selectedHospital.firstPhoto = UIImage(data:data! as Data)!
                                // newPlace.photos.append(UIImage(data:data! as Data)!)
                            }
                        }
                        firstOneDone = true
                    }
                }
                //printing the details in console for testing purpose
                print("PLace name is \(self.selectedHospital.name)")
                print("open now is \(self.selectedHospital.isOpen)")
                print("place id is \(self.selectedHospital.placeId)")
                print("place address is \(self.selectedHospital.address)")
                print("latitude is \(self.selectedHospital.lat)")
                print("price level is\(self.selectedHospital.priceLevel)")
                print("rating is \(self.selectedHospital.rating)")
                print("Webisite is \(self.selectedHospital.website)")
                print("url is \(self.selectedHospital.url)")
                print("no of photo reference is \(self.selectedHospital.photoReference.count)")
            }
            
        }
        catch{
            print("JSON Serialization error")
        }
        
        self.stopProgressView()
        performSegue(withIdentifier: "HospitalDetailSegue", sender: nil)
        
        
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
