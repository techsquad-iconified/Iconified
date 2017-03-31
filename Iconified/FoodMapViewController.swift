//
//  FoodMapViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 25/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//


import UIKit
import MapKit

class FoodMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var foodType: String?
    var latitude: Double?
    var longitude: Double?
    var placeArray: NSMutableArray
    var selectedPlace: Place
    var photoArray: [String]
    // declaring the global variables
    let locationManager: CLLocationManager
    
    // creating a view to display a progress spinner while data is being loaded from the server
    var progressView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        self.placeArray = NSMutableArray()
        self.foodType = nil
        self.latitude = nil
        self.longitude = nil
        self.selectedPlace = Place()
        self.photoArray = [String]()
        self.locationManager = CLLocationManager()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // setting up the progress view
        setProgressView()
        self.view.addSubview(self.progressView)
        
        self.mapView.delegate = self
        //call method to get users current location
        self.getUsersCurrentLocation()
    
        //Method to create the API call from the server
        DispatchQueue.main.async(){
           self.downloadLocationDataFromServer()
           //self.downloadLocationData()
        }

        
    }
    
    @IBAction func refreshActionSelected(_ sender: UIBarButtonItem) {
        self.viewDidLoad()
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
    }
    
    /*
     Puts an annotation on the map for the selected category
     */
    func addLocationAnnotations()
    {
        //remove all annotations already existing
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        if(self.placeArray.count != 0 )
        {
            for case let place as Place in placeArray
            {
                if (place.lat != nil)     // if it has a previous latitude
                {
                    let loc = CLLocationCoordinate2D(latitude: Double((place.lat)!) , longitude: Double((place.lng)!))
                    let center = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                    let point = RestaurantAnnotation(coordinate: loc)
                    
                    point.image = place.firstPhoto
                    
                    point.name = place.placeName
                    if(place.isOpen == "true" || place.isOpen == "false")
                    {
                        point.isOpen = place.isOpen
                    }
                    point.place = place
                    mapView.addAnnotation(point)
                   
                    let area = MKCoordinateRegion(center: center , span: MKCoordinateSpan(latitudeDelta: 0.005,longitudeDelta: 0.005))
                    mapView.setRegion(area, animated: true)
                }
            }
        }
        self.stopProgressView()
        
    }
    
    func downloadLocationDataFromServer()
    {
        var url: URL
        print("lat is \(self.latitude)")
        print("lat is \(self.longitude)")
        url = URL(string:"http://23.83.248.221/test?searchType=\(self.foodType!)&myLocation=\(self.latitude!),\(self.longitude!)")!
        print(url)
        let urlRequest = URLRequest(url: url)
        
        //set up session
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if (error != nil)    //checking if the any error message received during connection
            {
                print("Error \(error)")
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
    
    func parseServerJSON(articleJSON:NSData){
        
        var placeLat: Double = 0.0
        var placeLng: Double = 0.0
        var placeId: String = "unknown"
        var placeName: String = "unknown"
        var isOpen: String = "unavailable"
        var placeAddress: String = "unknown"
        var firstOneDone : Bool = false
     
        
        do{
             //  When the json data is from TIM api
             
             let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
             
             print("Json Data is \(jsonData)")
            for eachPlace in jsonData
            {
                firstOneDone = false
                let place = eachPlace as! NSDictionary
                print("Place is \(place)")
                
                if let location = place["location"] as? NSDictionary
                {
                    placeLat = location.object(forKey: "lat")! as! Double
                    placeLng = location.object(forKey: "lng")! as! Double
                    print("location is \(placeLat) and \(placeLng)")
                }
                placeAddress = place.object(forKey: "address") as! String
                placeName = place.object(forKey: "name") as! String
                placeId = place.object(forKey: "place_id") as! String
                isOpen = place.object(forKey: "open_now") as! String
               
                let newPlace = Place(lat: placeLat, lng: placeLng, placeId: placeId, placeName: placeName, placeAddress: placeAddress , isOpen: isOpen)
                
                newPlace.phoneNumber = place.object(forKey: "numbers") as? String
                newPlace.priceLevel = place.object(forKey: "price_level") as? Int
                newPlace.rating = place.object(forKey: "rating") as? Float
                newPlace.website = place.object(forKey: "website") as? String
                newPlace.url = place.object(forKey: "url") as? String
                
               if let photos = place["photos"] as? NSArray
                {
                    for photo in photos
                    {
                        let eachPhoto = photo as? NSDictionary
                        let reference: String = (eachPhoto?.object(forKey: "photo_reference") as? String)!
                        print("reference is \(reference)")
                        newPlace.photoReference.append(reference)
                        if(firstOneDone == false)
                        {
                            // retrieve images for each place.
                            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=AIzaSyAMW8Z_cdUbbVMMviRfe845JBj7xbKhRp4")!
                            print(url)
                            let data = NSData(contentsOf:url as URL)
                            if(data != nil)
                            {
                                print("Photo was not nil")
                                newPlace.firstPhoto = UIImage(data:data! as Data)!
                                // newPlace.photos.append(UIImage(data:data! as Data)!)
                            }
                        }
                        firstOneDone = true
                    }
                }
              
                self.placeArray.add(newPlace)
                
                print("PLace name is \(newPlace.placeName)")
                print("open now is \(newPlace.isOpen)")
                print("place id is \(newPlace.placeId)")
                print("place address is \(newPlace.placeAddress)")
                print("latitude is \(newPlace.lat)")
                print("price level is\(newPlace.priceLevel)")
                print("rating is \(newPlace.rating)")
                print("Webisite is \(newPlace.website)")
                print("url is \(newPlace.url)")
                print("no of photo reference is \(newPlace.photoReference.count)")
            }
            
        }
        catch{
            print("JSON Serialization error")
        }
        print("while parsing count is \(self.placeArray.count)")
    }
    
    /*
     func loadFirstPhotoForPlace(placeID: String)
     {
            GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
                if let error = error
                {
                    // TODO: handle the error.
                    print("Error: \(error.localizedDescription)")
                } else
                {
                    if let firstPhoto = photos?.results.first
                    {
                        self.loadImageForMetadata(photoMetadata: firstPhoto)
                    }
                }
            }
        }
        
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata)
    {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback:
            {
                (photo, error) -> Void in
                if let error = error
                {
                    // TODO: handle the error.
                    print("Error: \(error.localizedDescription)")
                }
                else
                {
                    self.imageView.image = photo;
                    self.attributionTextView.attributedText = photoMetadata.attributions;
                }
            })
    }
    */

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
        self.progressView.backgroundColor = UIColor.red
        self.progressView.layer.cornerRadius = 10
        let wait = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        wait.color = UIColor.white
            //UIColor(red: 254/255, green: 218/255, blue: 2/255, alpha: 1)
        wait.hidesWhenStopped = false
        wait.startAnimating()
        
        let message = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        message.text = "Finding \(self.foodType!)s..."
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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        if(self.foodType == "cafe")
        {
            annotationView?.image = UIImage(named: "Cafe Filled")
        }
        else if(self.foodType == "bar")
        {
            annotationView?.image = UIImage(named: "Wine")
        }
        else if(self.foodType == "restaurant")
        {
            annotationView?.image = UIImage(named: "Meal")
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        
        // 2
        let restaurantAnnotation = view.annotation as! RestaurantAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.restaurantName.text = restaurantAnnotation.name
        if(restaurantAnnotation.isOpen != nil)
        {
            calloutView.restaurantIsOpen.text = (restaurantAnnotation.isOpen == "true") ? "Open" : "Close"
        }
        
        calloutView.restaurantImage.image = restaurantAnnotation.image
        
        self.selectedPlace = restaurantAnnotation.place
       // self.getPlaceDetails(place: self.selectedPlace, calloutView: calloutView )
        print("Place is \(self.selectedPlace.placeName!)")
      
        //Adding gesture recognition for details icon
        let tapGestureRecogniserForTransportation = UITapGestureRecognizer(target: self, action:#selector(FoodMapViewController.detailsSelected))
        calloutView.detailsIcon.isUserInteractionEnabled = true
        calloutView.detailsIcon.addGestureRecognizer(tapGestureRecogniserForTransportation)

        calloutView.center = CGPoint(x: view.bounds.size.width / 4, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
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
        performSegue(withIdentifier: "FoodDetailSegue", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "FoodDetailSegue")
        {
           let destinationVC: FoodDetailViewController = segue.destination as! FoodDetailViewController
           destinationVC.selectedPlace = self.selectedPlace
        }
    }
    
    
    
    // CODE FOR GOOGLE API CALL
    /*
     
     // method to establish connection and download JSON data from the API
     func downloadLocationData() {
     
     var url: URL
     print("lat is \(self.latitude)")
     print("lat is \(self.longitude)")
     // url = URL(string:"http://23.83.248.221/apitest?searchType=food&myLocation=\(self.latitude!),\(self.longitude!)")!
     url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(self.latitude!),\(self.longitude!)&radius=1000&types=\(self.foodType!)&key=AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8")!
     print(url)
     let urlRequest = URLRequest(url: url)
     
     //set up session
     let session = URLSession.shared
     let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
     if (error != nil)    //checking if the any error message received during connection
     {
     print("Error \(error)")
     }
     else
     {
     self.parseJSON(articleJSON: data! as NSData)
     
     // Do any additional setup after loading the view.
     DispatchQueue.main.async(){
     self.addLocationAnnotations()
     }
     }
     })
     
     task.resume()
     
     }
     
     func parseJSON(articleJSON:NSData){
     
     var placeLat: Double?
     var placeLng: Double?
     var placeId: String?
     var placeName: String?
     var placeAddress: String?
     var isOpen: Bool?
     
     do{
     
     /*
     //  When the json data is from TIM api
     
     let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
     
     print(jsonData)
     */
     
     //When the json data is from Google Api
     let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
     
     
     if let result = jsonData["results"] as? NSArray
     {
     
     // print("Result is \(result)")
     for eachPlace in result
     {
     let place = eachPlace as! NSDictionary
     //  print("Place is \(place)")
     if let geometry = place["geometry"] as? NSDictionary
     {
     if let location = geometry["location"] as? NSDictionary
     {
     placeLat = location.object(forKey: "lat")! as! Double
     placeLng = location.object(forKey: "lng")! as! Double
     print("location is \(location)")
     }
     
     }
     placeName = place.object(forKey: "name")! as! String
     if let openingHours = place["opening_hours"] as? NSDictionary
     {
     print(" opening is \(openingHours)")
     isOpen = openingHours.object(forKey: "open_now") as! Bool
     }
     else{
     isOpen = false
     }
     placeId = place.object(forKey: "place_id") as! String
     placeAddress = place.object(forKey: "vicinity") as! String
     print("PLace name is \(placeName)")
     print("open now is \(isOpen)")
     print("place id is \(placeId)")
     print("place address is \(placeAddress)")
     self.placeArray.add(Place(lat: placeLat!, lng: placeLng!, placeId: placeId!, placeName: placeName!, placeAddress: placeAddress! , isOpen: isOpen!))
     }
     
     }
     
     }
     catch{
     print("JSON Serialization error")
     }
     
     }
     
     func getPlaceDetails(place: Place, calloutView: CustomCalloutView)
     {
     var url: URL
     url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(place.placeId!)&key=AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8")!
     print(url)
     let urlRequest = URLRequest(url: url)
     
     //set up session
     let session = URLSession.shared
     let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
     if (error != nil)    //checking if the any error message received during connection
     {
     print("Error \(error)")
     }
     else
     {
     print("GOT HERE")
     DispatchQueue.main.async(){
     self.parseDetailsJSON(articleJSON: data! as NSData, place: place as! Place, calloutView: calloutView )
     
     }
     
     }
     })
     
     task.resume()
     
     
     }
     
     func parseDetailsJSON(articleJSON:NSData, place: Place, calloutView: CustomCalloutView)
     {
     print("Place is \(place.placeName)")
     print("GOT HERE 1")
     do{
     
     //When the json data is from Google Api
     let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
     
     
     if let result = jsonData["result"] as? NSDictionary
     {
     place.phoneNumber = result.object(forKey: "formatted_phone_number")! as? String
     print("prev place address \(place.placeAddress) ")
     place.placeAddress = result.object(forKey: "formatted_address")! as? String
     place.priceLevel = result.object(forKey: "price_level") as? Int
     place.rating = result.object(forKey: "rating") as? Float
     place.website = result.object(forKey: "website") as? String
     place.url = result.object(forKey: "url") as? String
     
     if let photos = result["photos"] as? NSArray
     {
     for photo in photos
     {
     let eachPhoto = photo as? NSDictionary
     let reference: String = (eachPhoto?.object(forKey: "photo_reference") as? String)!
     print("reference is \(reference)")
     // retrieve images for each place.
     let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8")!
     print(url)
     let data = NSData(contentsOf:url as URL)
     if(data != nil)
     {
     print("Photo was not nil")
     place.photos.append(UIImage(data:data! as Data)!)
     
     }
     }
     }
     print("latitude is \(place.lat)")
     print("price level is\(place.priceLevel)")
     print("rating is \(place.rating)")
     print("phone address is \(place.placeAddress)")
     print("Webisite is \(place.website)")
     print("No of photos \(place.photos.count)")
     print("url is \(place.url)")
     
     }
     }
     catch{
     print("JSON Serialization error")
     }
     }
     
     
     */

}
