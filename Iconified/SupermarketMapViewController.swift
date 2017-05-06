//
//  AccommodationMapViewController.swift
//  Iconified
//
//  Created by 张翼扬 on 29/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit
import MapKit

/* The View Controller is linked to the Map view which represnts the various locations of the selected category
 around the user.
 The user location is checked.
 The selected type and user location is sent to the server to fetch required information
 The Place details is recorded and annotations are placed on the map
 */
class SupermarketMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, marketDelegate {
    
    //UI Mapview
    @IBOutlet var mapView: MKMapView!
    //Variable for the seleted category, and keyword
    var marketType: String?
    var keyword: String?
    //users location
    var latitude: Double?
    var longitude: Double?
    
    //Array of place details retrieved from the user
    var placeArray: NSMutableArray
    //Place on the map slected by the user
    var selectedPlace: Market
    //Array of photos
    var photoArray: [String]
    // declaring the global variable for location manager
    let locationManager: CLLocationManager
    
    // creating a view to display a progress spinner while data is being loaded from the server
    var progressView = UIView()
    
    let cuiseButton = UIButton.init(type: .custom)
    var selectedcuisine: String?

    //Initialiser
    required init?(coder aDecoder: NSCoder) {
        self.placeArray = NSMutableArray()
        self.marketType = nil
        self.keyword = nil
        self.latitude = nil
        self.longitude = nil
        self.selectedPlace = Market()
        self.photoArray = [String]()
        self.locationManager = CLLocationManager()
        super.init(coder: aDecoder)
    }
    
    //Method called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up the progress view
        setProgressView()
        self.view.addSubview(self.progressView)
        
        if(self.marketType == "grocery_or_supermarket")
        {
            self.title = "Supermarket"
            cuiseButton.setImage(UIImage.init(named: "Australia"), for: UIControlState.normal)
            cuiseButton.addTarget(self, action:#selector(SupermarketMapViewController.typeSelector), for: UIControlEvents.touchUpInside)
            cuiseButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
            let barButton = UIBarButtonItem.init(customView: cuiseButton)
            self.navigationItem.rightBarButtonItem = barButton
        }
        else if(self.marketType == "clothes")
        {
            self.title = "Clothes"
        }
        else
        {
            self.title = "Electronics"
        }
        self.mapView.delegate = self
        
        DispatchQueue.main.async(){
            //call method to get users current location
            self.getUsersCurrentLocation()
        }
        //Method to create the API call from the server
        DispatchQueue.main.async(){
            self.downloadLocationDataFromServer()
            //self.downloadLocationData()
        }
    }
    
    func typeSelected(type: String) {
        
        // setting up the progress view
        setProgressView()
        self.view.addSubview(self.progressView)
        cuiseButton.setImage(UIImage.init(named: type), for: UIControlState.normal)
        self.placeArray = NSMutableArray()
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        
        self.placeArray = NSMutableArray()
        self.apiCallToServerForType(type: type)
        print("In delegate method")
    }
  
    func typeSelector()
    {
        performSegue(withIdentifier: "typeSelectorSegue", sender: nil)
    }
    
    func generateURL() -> String
    {
        switch(self.selectedcuisine!)
        {
        case "China": return "http://23.83.248.221/test?searchType=grocery_or_supermarket&myLocation=\(self.latitude!),\(self.longitude!)&keyword=China"
        case "India": return "http://23.83.248.221/test?searchType=grocery_or_supermarket&myLocation=\(self.latitude!),\(self.longitude!)&keyword=India"
        case "Italy": return "http://23.83.248.221/test?searchType=grocery_or_supermarket&myLocation=\(self.latitude!),\(self.longitude!)&keyword=Italy"
        case "Japan": return "http://23.83.248.221/test?searchType=grocery_or_supermarket&myLocation=\(self.latitude!),\(self.longitude!)&keyword=Japan"
        case "Mexico": return "http://23.83.248.221/test?searchType=grocery_or_supermarket&myLocation=\(self.latitude!),\(self.longitude!)&keyword=Mexico"
        case "Vietnam": return "http://23.83.248.221/test?searchType=grocery_or_supermarket&myLocation=\(self.latitude!),\(self.longitude!)&keyword=Vietnam"
        default: return "http://23.83.248.221/test?searchType=grocery_or_supermarket&myLocation=\(self.latitude!),\(self.longitude!)&keyword=Australia"
        }
    }

    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let sourceController = segue.source as! SuperTableViewController
        // self.title = sourceController.currentItem
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
        print("Users Current location \(self.longitude) and \(self.longitude)")
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
            print("in add annotation in if")
            for case let market as Market in placeArray
            {
                print("IN FOR")
                if (market.lat != nil)     // if it has a previous latitude
                {
                    print("IN FOR-IF")
                    let loc = CLLocationCoordinate2D(latitude: Double((market.lat)!) , longitude: Double((market.lng)!))
                    let center = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
                    let point = MarketAnnotation(coordinate: loc)
                    
                    point.image = market.firstPhoto
                    point.name = market.placeName
                    print("name is \(point.name)")
                    if(market.isOpen == "true" || market.isOpen == "false")
                    {
                        point.isOpen = market.isOpen
                    }
                    point.Market = market
                    self.mapView.addAnnotation(point)
                    
                    let area = MKCoordinateRegion(center: center , span: MKCoordinateSpan(latitudeDelta: 0.005,longitudeDelta: 0.005))
                    self.mapView.setRegion(area, animated: true)
                    self.mapView.showAnnotations(mapView.annotations, animated: true)
                }
            }
        }
        self.stopProgressView()
        
    }
    //Function make api call to server for supermarkets based on a different type.
    func apiCallToServerForType(type: String)
    {
        var url: URL
        url = URL(string:"http://23.83.248.221/test?searchType=\(self.marketType!)&myLocation=\(self.latitude!),\(self.longitude!)&keyword=\(self.getTypeForCountry(country: type))")!
        
        print("url isss \(url)")
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
    
    func getTypeForCountry(country: String) -> String
    {
        //"Australia", "China", "India", "Italy", "Japan", "Mexico", "Vietnam"]
        switch(country)
        {
            case "Australia": return ""
            case "China": return "Chinese"
            case "India": return "Indian"
            case "Italy": return "Italian"
            case "Japan": return "Japanese"
            case "Mexico": return "Mexican"
            case "Vietnam": return "Vietnamese"

        default: return ""
            
        }
    }
    
    //Function makes a API call to the server to fetch the required place details
    func downloadLocationDataFromServer()
    {
        var url: URL
        if(self.keyword != nil)
        {
            url = URL(string:"http://23.83.248.221/test?searchType=\(self.marketType!)&myLocation=\(self.latitude!),\(self.longitude!)&keyword=\(self.keyword!)")!
        }
        else
        {
        url = URL(string:"http://23.83.248.221/test?searchType=\(self.marketType!)&myLocation=\(self.latitude!),\(self.longitude!)")!
        }
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
        var placeAddress: String = "unknown"
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
                placeAddress = place.object(forKey: "address") as! String
                placeName = place.object(forKey: "name") as! String
                placeId = place.object(forKey: "place_id") as! String
                isOpen = place.object(forKey: "open_now") as! String
                
                //create a object of place for the details obtained
                let newPlace = Market(lat: placeLat, lng: placeLng, placeId: placeId, placeName: placeName, placeAddress: placeAddress , isOpen: isOpen)
                //addtional details for the place
                newPlace.phoneNumber = place.object(forKey: "numbers") as? String
                newPlace.priceLevel = place.object(forKey: "price_level") as? Int
                newPlace.rating = place.object(forKey: "rating") as? Float
                newPlace.website = place.object(forKey: "website") as? String
                newPlace.url = place.object(forKey: "url") as? String
                
                //If photo exists get the first photo and an array of photo reference string.
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
                            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8")!
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
                //Add the place to the placeArray
                self.placeArray.add(newPlace)
                
                //printing the details in console for testing purpose
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
            
        if marketType == "clothes"
        {
            message.text = "Finding clothes shop..."
        }
            
        else
        {
            message.text = "Finding  markets..."
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
        if(self.marketType == "grocery_or_supermarket")
        {
            //hotel annotation
            let pinImage = UIImage(named: "shop2")
            let size = CGSize(width: 20, height: 20)
            UIGraphicsBeginImageContext(size)
            pinImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView?.image = resizedImage
        }
        else if(self.keyword == "electronics")
        {
            //electronics annotation
            let pinImage = UIImage(named: "electronics annotation")
            let size = CGSize(width: 20, height: 20)
            UIGraphicsBeginImageContext(size)
            pinImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView?.image = resizedImage
            //agency annotation
        }
        else if(self.keyword == "clothes")
        {
            //clothes annotation
            let pinImage = UIImage(named: "Clothes annotation")
            let size = CGSize(width: 20, height: 20)
            UIGraphicsBeginImageContext(size)
            pinImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView?.image = resizedImage
        }
        else if(self.keyword == "vegetables")
        {
            //clothes annotation
            let pinImage = UIImage(named: "Vegetables")
            let size = CGSize(width: 20, height: 20)
            UIGraphicsBeginImageContext(size)
            pinImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView?.image = resizedImage
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
        
        // if other anotations selected supermarket annotation
        let MarketAnnotation = view.annotation as! MarketAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        //get the callout view
        let calloutView = views?[0] as! CallViewCustom
        //Add Image, name, open status and a details icon
        calloutView.restaurantName.text = MarketAnnotation.name
        if(MarketAnnotation.isOpen != nil)
        {
            calloutView.restaurantIsOpen.text = (MarketAnnotation.isOpen == "true") ? "Open" : "Close"
        }
        
        calloutView.restaurantImage.image = MarketAnnotation.image
        self.selectedPlace = MarketAnnotation.Market
        
        //Adding gesture recognition for details icon
        let tapGestureRecogniserForTransportation = UITapGestureRecognizer(target: self, action:#selector(FoodMapViewController.detailsSelected))
        calloutView.detailsIcon.isUserInteractionEnabled = true
        calloutView.detailsIcon.addGestureRecognizer(tapGestureRecogniserForTransportation)
        
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
        performSegue(withIdentifier: "SupermarketDetailSegue", sender: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SupermarketDetailSegue")
        {
            let destinationVC: SupermarketDetailViewController = segue.destination as! SupermarketDetailViewController
            destinationVC.selectedPlace = self.selectedPlace
            

        }
        if(segue.identifier == "typeSelectorSegue")
        {
            let destinationCuisineVC: SuperTableViewController = segue.destination as! SuperTableViewController
            destinationCuisineVC.delegate = self
            
            
        }
      
    }
      //Method to dismiss view
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    

}
