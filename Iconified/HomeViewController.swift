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

    @IBOutlet weak var FoodIcon: UIImageView!
    @IBOutlet weak var TransportationIcon: UIImageView!
    
   
    
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
    
    
    
    //Initialiser
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     This method is called when the transportation icon is clicked (using gesture control feature)
     */
    func transportationSelected()
    {
        print("Image clicked")
        performSegue(withIdentifier: "TransportationSegue", sender: nil)
        
    }

    /*
    This method is called when the food icon is clicked (using gesture control feature)
    */
    func foodSelected()
    {
        print("Image clicked")
        performSegue(withIdentifier: "FoodSegue", sender: nil)
        
    }
 
    
    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "TransportationSegue")
        {
            let destinationTransportationVC:TransportationViewController = segue.destination as! TransportationViewController
            
        }
        if(segue.identifier == "FoodSegue")
        {
            let destinationFoodVC: FoodViewController = segue.destination as! FoodViewController
           
            
        }
    }
    

}
