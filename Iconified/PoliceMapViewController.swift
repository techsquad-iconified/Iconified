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
    //selcted annotation
    var selectedAnnotation: EmergencyAnnotation
    //Array of place details retrieved from the user
    var policeArray: NSMutableArray
    
    // declaring the global variable for location manager
    let locationManager: CLLocationManager
    
    // creating a view to display a progress spinner while data is being loaded from the server
    var progressView = UIView()
    
    //Images used to represent the rating of the place
    let fullStarImage:  UIImage = UIImage(named: "Star Full")!
    let halfStarImage:  UIImage = UIImage(named: "Star Half")!
    let emptyStarImage: UIImage = UIImage(named: "Star Grey")!
    
    //Initialiser
    required init?(coder aDecoder: NSCoder) {
        self.policeArray = NSMutableArray()
        self.selectedPolice = Hospital()
        self.latitude = nil
        self.longitude = nil
        self.selectedAnnotation = EmergencyAnnotation()
        self.locationManager = CLLocationManager()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        // setting up the progress view
        setProgressView(type: "Police")
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
            let cleanedArray: NSMutableArray = self.cleanData(array: self.policeArray)
            for case let hospital as Hospital in cleanedArray
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
       
    }
    //Method to remove places which are not police stations
    func cleanData(array: NSMutableArray) -> NSMutableArray
    {
        var cleanedArray = NSMutableArray()
        for case let place as Hospital in array
        {
            if(place.name?.contains("Police"))!
            {
                cleanedArray.add(place)
            }
            else
            {
                print("Rejected \(place.name)")
            }
        }
        return cleanedArray
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
        if type == "Police"
        {
            message.text = "Finding police..."
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
        //annotationView?.image = UIImage(named: "Police Station")
        //agency annotation
        let pinImage = UIImage(named: "Police Station")
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        pinImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        //  pinImage.draw(in: CGRect(0, 0, size.width, size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        annotationView?.image = resizedImage
        
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
        calloutView.openLabel.text = "Open"
        
       /* if(emergencyAnnotation.image.size == CGSize(width: 0.0, height: 0.0))
        {
            calloutView.imageView.image = UIImage(named: "Police Station")
        }
        else
        {
            calloutView.imageView.image = emergencyAnnotation.image
        }
         */
        self.selectedPolice = emergencyAnnotation.hospital
        self.selectedAnnotation = emergencyAnnotation
        self.getRating(calloutView: calloutView)

        //Adding gesture recognition for details icon
        let tapGestureRecogniserForDetailIcon = UITapGestureRecognizer(target: self, action:#selector(PoliceMapViewController.detailsSelected))
        calloutView.detailsButton.isUserInteractionEnabled = true
        calloutView.detailsButton.addGestureRecognizer(tapGestureRecogniserForDetailIcon)
        
        //Adding gesture recognition for image icon
        let tapGestureRecogniserForName = UITapGestureRecognizer(target: self, action:#selector(PoliceMapViewController.detailsSelected))
        calloutView.nameLabel.isUserInteractionEnabled = true
        calloutView.nameLabel.addGestureRecognizer(tapGestureRecogniserForName)
        
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
    
    //method called wheh details button in the callout view is called
    func detailsSelected()
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

    //Funtion displays the rating of teh place using images of stars
    func getRating(calloutView: EmergencyCallout)
    {
        if(self.selectedPolice.rating != nil)
        {
            if let ourRating = self.selectedPolice.rating
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

    //Function makes a API call to the server to fetch the required place details
    func downloadLocationDataFromServer()
    {
        var url: URL
        //url = URL(string:"http://23.83.248.221/test?searchType=police&myLocation=-37.877009,145.046267")!
        url = URL(string:"http://23.83.248.221/generalquery?searchType=police&myLocation=\(self.latitude!),\(self.longitude!)")!
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
                
                
                //Add the place to the placeArray
                self.policeArray.add(newPlace)
                
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
        print("while parsing count is \(self.policeArray.count)")
    }
    
    //Method to download details of the selected place from server
    func downloadPlaceDetailsFromServer()
    {
        var url: URL
        //  url = URL(string:"http://23.83.248.221/test?searchType=\(self.bankType!)&myLocation=\(self.latitude!),\(self.longitude!)")!
        url = URL(string:"http://23.83.248.221/detailedquery?placeId=\(self.selectedPolice.placeId!)")!
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
                self.selectedPolice.address = place.object(forKey: "address") as? String
                self.selectedPolice.phoneNumber = place.object(forKey: "numbers") as? String
                self.selectedPolice.priceLevel = place.object(forKey: "price_level") as? Int
                self.selectedPolice.website = place.object(forKey: "website") as? String
                self.selectedPolice.url = place.object(forKey: "url") as? String
                
                //If photo exists get the first photo and an array of photo reference string.
                if let photos = place["photos"] as? NSArray
                {
                    for photo in photos
                    {
                        let eachPhoto = photo as? NSDictionary
                        let reference: String = (eachPhoto?.object(forKey: "photo_reference") as? String)!
                        print("reference is \(reference)")
                        self.selectedPolice.photoReference.append(reference)
                        if(firstOneDone == false)
                        {
                            // retrieve images for each place.
                            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8")!
                            print(url)
                            let data = NSData(contentsOf:url as URL)
                            if(data != nil)
                            {
                                print("Photo was not nil")
                                self.selectedPolice.firstPhoto = UIImage(data:data! as Data)!
                                // newPlace.photos.append(UIImage(data:data! as Data)!)
                            }
                        }
                        firstOneDone = true
                    }
                }
                //printing the details in console for testing purpose
                print("PLace name is \(self.selectedPolice.name)")
                print("open now is \(self.selectedPolice.isOpen)")
                print("place id is \(self.selectedPolice.placeId)")
                print("place address is \(self.selectedPolice.address)")
                print("latitude is \(self.selectedPolice.lat)")
                print("price level is\(self.selectedPolice.priceLevel)")
                print("rating is \(self.selectedPolice.rating)")
                print("Webisite is \(self.selectedPolice.website)")
                print("url is \(self.selectedPolice.url)")
                print("no of photo reference is \(self.selectedPolice.photoReference.count)")
            }
            
        }
        catch{
            print("JSON Serialization error")
        }
        print("while parsing count is \(self.policeArray.count)")
        
        self.stopProgressView()
        performSegue(withIdentifier: "PoliceDetailSegue", sender: nil)
        
        
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PoliceDetailSegue") //Preparing variables for police detail segue
        {
            let destinationDetailVC: EmergenyDetailViewController = segue.destination as! EmergenyDetailViewController
            destinationDetailVC.selectedPlace = self.selectedPolice
            destinationDetailVC.gpSelected = false
        }
        
        
    }
    
    
}
