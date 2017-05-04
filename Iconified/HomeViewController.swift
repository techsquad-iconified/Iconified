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
 
 */

import UIKit
import MapKit

class HomeViewController: UIViewController {

    //Initial icons representing th various facilities provided by the application
    @IBOutlet weak var FoodIcon: UIImageView!

    @IBOutlet weak var AccommodationIcon: UIImageView!
    @IBOutlet weak var TransportationIcon: UIImageView!
    

    @IBOutlet var BankIcon: UIImageView!
   
    @IBOutlet var shoppingIcon: UIImageView!
    
    @IBOutlet var emergencyIcon: UIImageView!
    
    // Setup method when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Loaded")
        
       
        //Adding gesture recognition for transportation icon
        let tapGestureRecogniserForTransportation = UITapGestureRecognizer(target: self, action:#selector(HomeViewController.transportationSelected))
        TransportationIcon.isUserInteractionEnabled = true
        TransportationIcon.addGestureRecognizer(tapGestureRecogniserForTransportation)
        
        //Adding gesture recognition for Food icon
        let tapGestureRecogniserForFood = UITapGestureRecognizer(target: self, action:#selector(HomeViewController.foodSelected))
        FoodIcon.isUserInteractionEnabled = true
        FoodIcon.addGestureRecognizer(tapGestureRecogniserForFood)
        
   //Adding gesture recognition for Accommodation icon
        let tapGestureRecogniserForAccommodation = UITapGestureRecognizer(target: self, action:#selector(HomeViewController.AccommodationSelected))
        AccommodationIcon.isUserInteractionEnabled = true
        AccommodationIcon.addGestureRecognizer(tapGestureRecogniserForAccommodation)
    
        
        //Adding gesture recognition for Bank icon
        let tapGestureRecogniserForBank = UITapGestureRecognizer(target: self, action:#selector(HomeViewController.bankSelected))
        BankIcon.isUserInteractionEnabled = true
        BankIcon.addGestureRecognizer(tapGestureRecogniserForBank)
        
        //Adding gesture recognition for Shopping icon
        let tapGestureRecogniserForShopping = UITapGestureRecognizer(target: self, action:#selector(HomeViewController.shoppingSelected))
        shoppingIcon.isUserInteractionEnabled = true
        shoppingIcon.addGestureRecognizer(tapGestureRecogniserForShopping)
        
        //Adding gesture recognition for emergency icon
        let tapGestureRecogniserForEmergency = UITapGestureRecognizer(target: self, action:#selector(HomeViewController.emergencySelected))
        emergencyIcon.isUserInteractionEnabled = true
        emergencyIcon.addGestureRecognizer(tapGestureRecogniserForEmergency)
        
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
  
    
    //This method is called when the Bank icon is clicked (using gesture control feature)
    func bankSelected()
    {
        print("Image clicked")
        if(self.checkInternetConnection())
        {
            performSegue(withIdentifier: "BankSegue", sender: nil)
        }
    }
    //This method is called when the Bank icon is clicked (using gesture control feature)
    func shoppingSelected()
    {
        print("Image clicked")
        if(self.checkInternetConnection())
        {
            performSegue(withIdentifier: "SupermarketSegue", sender: nil)
        }
    }
    //This method is called when the Bank icon is clicked (using gesture control feature)
    func emergencySelected()
    {
        print("Image clicked")
        if(self.checkInternetConnection())
        {
            performSegue(withIdentifier: "emergencySegue", sender: nil)
        }
    }
 

    //This method is called when the Accommodation icon is clicked (using gesture control feature)
    func AccommodationSelected()
    {
        print("Image clicked")
        if(self.checkInternetConnection())
        {
            performSegue(withIdentifier: "AccommodationSegue", sender: nil)
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
            let destinationTransportationVC:TransportationDetailsViewController = segue.destination as! TransportationDetailsViewController
        }
        //Segue directing to the Accommodation facilities
        if(segue.identifier == "AccommodationSegue")
        {
            let destinationAccommodationVC:AccommodationViewController = segue.destination as! AccommodationViewController
        }

       
    }
    

}
