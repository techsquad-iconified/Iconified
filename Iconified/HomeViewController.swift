//
//  HomeViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 21/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

/* The View Controller is linked to the main screen of the application
   It conists of a grid of icons representing various facilities in the application
   On selecting a specific facility, the user is redirected to the faclity page
 
   The controller tracks the user's current location and passes it to the following screens.
 */

import UIKit
import MapKit

class HomeViewController: UIViewController {

    //Initial icons representing th various facilities provided by the application
    @IBOutlet weak var FoodIcon: UIImageView!
    @IBOutlet weak var TransportationIcon: UIImageView!
    
   
    // Setup method when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Loaded")
        
        //Adding gesture recognition for transportation icon
        let tapGestureRecogniserForTransportation = UITapGestureRecognizer(target: self, action:#selector(HomeViewController.transportationSelected))
        TransportationIcon.isUserInteractionEnabled = true
        TransportationIcon.addGestureRecognizer(tapGestureRecogniserForTransportation)
        
        //Adding gesture recognition for transportation icon
        let tapGestureRecogniserForFood = UITapGestureRecognizer(target: self, action:#selector(HomeViewController.foodSelected))
        FoodIcon.isUserInteractionEnabled = true
        FoodIcon.addGestureRecognizer(tapGestureRecogniserForFood)
        
    }
    
    
    
    //Initialiser method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //Inherit memory issues warning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkInternetConnection() -> Bool
    {
        if Reachability.isConnectedToNetwork() == true   //Checking for internet connection
        {
            print("Internet connection OK")
            return true          //call method to retrieve data from the API
        }
        else
        {
            print("Internet connection FAILED")     //Alert user if no internet connection
            let alert = UIAlertController(title: "No Network Connection!", message: "Please turn on your mobile data in settings.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    
    //This method is called when the transportation icon is clicked (using gesture control feature)
    func transportationSelected()
    {
        print("Image clicked")
        if(self.checkInternetConnection())
        {
            performSegue(withIdentifier: "TransportationSegue", sender: nil)
        }
    }

    
    //This method is called when the food icon is clicked (using gesture control feature)
    func foodSelected()
    {
        print("Image clicked")
        if(self.checkInternetConnection())
        {
            performSegue(withIdentifier: "FoodSegue", sender: nil)
        }
    }
 
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segue directing to the Food facilities
        if(segue.identifier == "FoodSegue")
        {
            let destinationFoodVC: FoodViewController = segue.destination as! FoodViewController
        }
        //Segue directing to the Transportation facilities 
        if(segue.identifier == "TransportationSegue")
        {
            let destinationTransportationVC:TransportationViewController = segue.destination as! TransportationViewController
        }
       
    }
    

}
