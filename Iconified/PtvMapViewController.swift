//
//  PtvMapViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 10/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit
import MapKit

class PtvMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {

    @IBOutlet var ptvMapView: MKMapView!
    //users location
    var latitude: Double?
    var longitude: Double?
    // declaring the global variable for location manager
    let locationManager: CLLocationManager

    required init?(coder aDecoder: NSCoder) {
        self.latitude = nil
        self.longitude = nil
        self.locationManager = CLLocationManager()
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ptvMapView.delegate = self
        //call method to get users current location
        self.getUsersCurrentLocation()
        
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
        print("Lat and lng of the user is \(self.latitude) and \(self.longitude)")
    }
    
    //Function makes a API call to the server to fetch the required place details
    func downloadLocationDataFromServer()
    {
        print("Lat and lng of the user is \(self.latitude!) and \(self.longitude!)")
        var url: URL
       // url = URL(string:"http://23.83.248.221/test?searchType=\(self.foodType!)&myLocation=\(self.latitude!),\(self.longitude!)")!
        url = URL(string:"http://timetableapi.ptv.vic.gov.au/v3/stops/location/\(self.latitude!),\(self.longitude!)?devid=3000212&signature=74723B0324AADE37AA87D3B45A888509F525170A")!
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
                  //  self.addLocationAnnotations()
                }
            }
        })
        
        task.resume()
    }
    
    //Method to parse the JSON response from the server
    func parseServerJSON(articleJSON:NSData)
    {
        //Local variables to store place details
        
        
        do{
            let jsonData = try JSONSerialization.jsonObject(with: articleJSON as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
            print("Json Data is \(jsonData)")
            /*for eachPlace in jsonData
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
                let newPlace = Place(lat: placeLat, lng: placeLng, placeId: placeId, placeName: placeName, placeAddress: placeAddress , isOpen: isOpen)
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
            }*/
            
        }
        catch{
            print("JSON Serialization error")
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
