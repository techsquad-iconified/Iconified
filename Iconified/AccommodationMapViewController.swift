//
//  AccommodationMapViewController.swift
//  Iconified
//
//  Created by 张翼扬 on 4/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit
import MapKit

/* The View Controller is linked to the Map view which represnts the various locations of the selected category around the user. The user location is checked.
 The selected type and user location is sent to the server to fetch required information
 The Place details is recorded and annotations are placed on the map
 */
class AccommodationMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //UI Mapview
    @IBOutlet var mapView: MKMapView!
    //Variable for the seleted category
    var accommodationType: String?
    //users location
    var latitude: Double?
    var longitude: Double?
    
    //Array of place details retrieved from the user
    var placeArray: NSMutableArray
    //Place on the map slected by the user
    var selectedPlace: Place
    //selcted annotation
    var selectedAnnotation: HotelAnnotation
    //Array of photos
    var photoArray: [String]
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
        self.placeArray = NSMutableArray()
        self.accommodationType = nil
        self.latitude = nil
        self.longitude = nil
        self.selectedPlace = Place()
        self.photoArray = [String]()
        self.selectedAnnotation = HotelAnnotation()
        self.locationManager = CLLocationManager()
        super.init(coder: aDecoder)
    }
    
    //Method called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up the progress view
        setProgressView(type: self.accommodationType!)
        self.view.addSubview(self.progressView)
        
        self.mapView.delegate = self
        //call method to get users current location
        self.getUsersCurrentLocation()
        
        if(self.accommodationType! == "lodging")
        {
            self.title = "Hotels & Motels"
        }
        else
        {
            self.title = "Accomodation Agents"
        }
        
        //Method to create the API call from the server
        DispatchQueue.main.async(){
            self.downloadLocationDataFromServer()
            //self.downloadLocationData()
        }
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
     Function adds annotations on the map for the selected category
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
                    let point = HotelAnnotation(coordinate: loc)
                    
                    point.image = place.firstPhoto
                    
                    point.name = place.placeName
                    if(place.isOpen == "true" || place.isOpen == "false")
                    {
                        point.isOpen = place.isOpen
                    }
                    point.place = place
                    mapView.addAnnotation(point)
                    
                    let area = MKCoordinateRegion(center: center , span: MKCoordinateSpan(latitudeDelta: 0.003,longitudeDelta: 0.003))
                    mapView.setRegion(area, animated: true)
                    mapView.showAnnotations(mapView.annotations, animated: true)
                }
            }
        }
        self.stopProgressView()
        
    }
    //Function makes a API call to the server to fetch the required place details
    func downloadLocationDataFromServer()
    {
        var url: URL
       // url = URL(string:"http://23.83.248.221/test?searchType=\(self.accommodationType!)&myLocation=\(self.latitude!),\(self.longitude!)")!
        url = URL(string:"http://23.83.248.221/generalquery?searchType=\(self.accommodationType!)&myLocation=\(self.latitude!),\(self.longitude!)")!
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
        //Local variables to store place details
        var placeLat: Double = 0.0
        var placeLng: Double = 0.0
        var placeId: String = "unknown"
        var placeName: String = "unknown"
        var isOpen: String = "unavailable"
        //var placeAddress: String = "unknown"
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
                placeName = place.object(forKey: "name") as! String
                placeId = place.object(forKey: "place_id") as! String
                isOpen = place.object(forKey: "open_now") as! String
                
                //create a object of place for the details obtained
                let newPlace = Place(lat: placeLat, lng: placeLng, placeId: placeId, placeName: placeName, isOpen: isOpen)
                //addtional details for the place
                newPlace.rating = place.object(forKey: "rating") as? Float
                
                
                //Add the place to the placeArray
                self.placeArray.add(newPlace)
                
                //printing the details in console for testing purpose
                print("PLace name is \(newPlace.placeName)")
                print("open now is \(newPlace.isOpen)")
                print("place id is \(newPlace.placeId)")
                print("rating is \(newPlace.rating)")
            }
        }
        catch{
            print("JSON Serialization error")
        }
        print("while parsing count is \(self.placeArray.count)")
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
        self.progressView = UIView(frame: CGRect(x: 0, y: 0, width: 280, height: 50))
        self.progressView.backgroundColor = UIColor.darkGray
        self.progressView.layer.cornerRadius = 10
        let wait = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        wait.color = UIColor.white
        //UIColor(red: 254/255, green: 218/255, blue: 2/255, alpha: 1)
        wait.hidesWhenStopped = false
        wait.startAnimating()
        var message: UILabel!
        
        if(type == "lodging")
        {
             message = UILabel(frame: CGRect(x: 60, y: 0, width: 250, height: 50))
             message.text = "Finding hotels/motels..."
        }
        else if (type == "details")
        {
            message = UILabel(frame: CGRect(x: 60, y: 0, width: 250, height: 50))
            message.text = "Getting details..."
        }
        else
        {
            message = UILabel(frame: CGRect(x: 60, y: 0, width: 280, height: 50))
            message.text = "Finding estate agents..."
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
        if(self.accommodationType == "lodging")
        {
            //hotel annotation
            let pinImage = UIImage(named: "hotelred")
            let size = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContext(size)
            pinImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
          //  pinImage.draw(in: CGRect(0, 0, size.width, size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
             annotationView?.image = resizedImage
        }
        else if(self.accommodationType == "real_estate_agency")
        {
            //agency annotation
            let pinImage = UIImage(named: "Real Estate-50")
            let size = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContext(size)
            pinImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            //  pinImage.draw(in: CGRect(0, 0, size.width, size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView?.image = resizedImage
  //agency annotation
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
        
        // if other anotations selected hotel annotation
        let hotelAnnotation = view.annotation as! HotelAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        //get the callout view
        let calloutView = views?[0] as! CallViewCustom
        //Add Image, name, open status and a details icon
        calloutView.nameLabel.text = hotelAnnotation.name
       if(hotelAnnotation.isOpen != nil)
        {
            calloutView.openLabel.text = (hotelAnnotation.isOpen == "true") ? "Open" : "Close"
        }
    
        self.selectedPlace = hotelAnnotation.place
        self.selectedAnnotation = hotelAnnotation
        //Adding gesture recognition for details icon
        let tapGestureRecogniserForTransportation = UITapGestureRecognizer(target: self, action:#selector(AccommodationMapViewController.detailsSelected))
        calloutView.detailsButton.isUserInteractionEnabled = true
        calloutView.detailsButton.addGestureRecognizer(tapGestureRecogniserForTransportation)
        
        //Adding gesture recognition for image icon
        let tapGestureRecogniserForName = UITapGestureRecognizer(target: self, action:#selector(AccommodationMapViewController.detailsSelected))
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
    //Method is called when the details icon is selected
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
    func getRating(calloutView: SupermarketCallout)
    {
        if(self.selectedPlace.rating != nil)
        {
            if let ourRating = self.selectedPlace.rating
            {
                calloutView.ratingOne.image = getStarImage(starNumber: 1, forRating: ourRating)
                calloutView.ratingTwo.image = getStarImage(starNumber: 2, forRating: ourRating)
                calloutView.ratingThree.image = getStarImage(starNumber: 3, forRating: ourRating)
                calloutView.ratingFour.image = getStarImage(starNumber: 4, forRating: ourRating)
                calloutView.ratingFive.image = getStarImage(starNumber: 5, forRating: ourRating)
            }
        }
        else
        {
            //If rating data is missing - inform the user as "unavailable"
            //calloutView.noRatingLabel.tintColor = UIColor.gray
            //calloutView.noRatingLabel.text = "Unavailable"
            
            /*
             self.ratingOne.image = emptyStarImage
             self.ratingTwo.image = emptyStarImage
             self.ratingThree.image = emptyStarImage
             self.ratingFour.image = emptyStarImage
             self.ratingFive.image = emptyStarImage
             */
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

    //Method to download details of the selected place from server
    func downloadPlaceDetailsFromServer()
    {
        var url: URL
        //  url = URL(string:"http://23.83.248.221/test?searchType=\(self.bankType!)&myLocation=\(self.latitude!),\(self.longitude!)")!
        url = URL(string:"http://23.83.248.221/detailedquery?placeId=\(self.selectedPlace.placeId!)")!
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
                self.selectedPlace.placeAddress = place.object(forKey: "address") as? String
                self.selectedPlace.phoneNumber = place.object(forKey: "numbers") as? String
                self.selectedPlace.priceLevel = place.object(forKey: "price_level") as? Int
                self.selectedPlace.website = place.object(forKey: "website") as? String
                self.selectedPlace.url = place.object(forKey: "url") as? String
                
                //If photo exists get the first photo and an array of photo reference string.
                if let photos = place["photos"] as? NSArray
                {
                    for photo in photos
                    {
                        let eachPhoto = photo as? NSDictionary
                        let reference: String = (eachPhoto?.object(forKey: "photo_reference") as? String)!
                        print("reference is \(reference)")
                        self.selectedPlace.photoReference.append(reference)
                        if(firstOneDone == false)
                        {
                            // retrieve images for each place.
                            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8")!
                            print(url)
                            let data = NSData(contentsOf:url as URL)
                            if(data != nil)
                            {
                                print("Photo was not nil")
                                self.selectedPlace.firstPhoto = UIImage(data:data! as Data)!
                                // newPlace.photos.append(UIImage(data:data! as Data)!)
                            }
                        }
                        firstOneDone = true
                    }
                }
                //printing the details in console for testing purpose
                print("PLace name is \(self.selectedPlace.placeName)")
                print("open now is \(self.selectedPlace.isOpen)")
                print("place id is \(self.selectedPlace.placeId)")
                print("place address is \(self.selectedPlace.placeAddress)")
                print("latitude is \(self.selectedPlace.lat)")
                print("price level is\(self.selectedPlace.priceLevel)")
                print("rating is \(self.selectedPlace.rating)")
                print("Webisite is \(self.selectedPlace.website)")
                print("url is \(self.selectedPlace.url)")
                print("no of photo reference is \(self.selectedPlace.photoReference.count)")
            }
            
        }
        catch{
            print("JSON Serialization error")
        }
        print("while parsing count is \(self.placeArray.count)")
        
        self.stopProgressView()
        performSegue(withIdentifier: "AccommodationDetailSegue", sender: nil)
        
        
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AccommodationDetailSegue")
        {
            let destinationVC: FoodDetailViewController = segue.destination as! FoodDetailViewController
            destinationVC.selectedPlace = self.selectedPlace
        }
}
}
