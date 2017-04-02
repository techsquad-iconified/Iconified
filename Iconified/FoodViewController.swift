//
//  FoodViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 21/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//
/*  The View Controller is linked to the food feature on the main screen of the application.
    It conists of a grid of icons representing various styles(restaurant, cafe or drinks) of food facilities provided by the application
    On selecting a specific facility, the user is redirected to the map page
 */

import UIKit

class FoodViewController: UIViewController {
    
    //Variabes representing user's location
    var latitude: Double?
    var longitude: Double?
    //Array of places in the particular category
    var placeArray: NSMutableArray
    //Type food style selected by the user
    var foodType: String?
    
    //UI attributes
    @IBOutlet weak var mealIcon: UIImageView!
    @IBOutlet weak var coffeeIcon: UIImageView!
    @IBOutlet weak var drinksIcon: UIImageView!
    
    //Intilaliser
    required init?(coder aDecoder: NSCoder) {
        self.latitude = nil
        self.longitude = nil
        self.foodType = nil
        self.placeArray = NSMutableArray()
        super.init(coder: aDecoder)
    }

    //method called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding gesture recognition for meal icon
        let tapGestureRecogniserForMeal = UITapGestureRecognizer(target: self, action:#selector(FoodViewController.mealSelected))
        mealIcon.isUserInteractionEnabled = true
        mealIcon.addGestureRecognizer(tapGestureRecogniserForMeal)
        
        //Adding gesture recognition for coffee icon
        let tapGestureRecogniserForCoffee = UITapGestureRecognizer(target: self, action:#selector(FoodViewController.coffeeSelected))
        coffeeIcon.isUserInteractionEnabled = true
        coffeeIcon.addGestureRecognizer(tapGestureRecogniserForCoffee)
        
        //Adding gesture recognition for drinks icon
        let tapGestureRecogniserForDrinks = UITapGestureRecognizer(target: self, action:#selector(FoodViewController.drinksSelected))
        drinksIcon.isUserInteractionEnabled = true
        drinksIcon.addGestureRecognizer(tapGestureRecogniserForDrinks)

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Method is called when the meal icon is selected
    func mealSelected()
    {
        self.foodType = "restaurant"
        performSegue(withIdentifier: "FoodMapSegue", sender: nil)
        print("meal selected")
    }

    //method is called when coffee icon is selected
    func coffeeSelected()
    {
        //self.downloadLocationData()
        self.foodType = "cafe"
        performSegue(withIdentifier: "FoodMapSegue", sender: nil)
    }
    
    //method is called when drinks icon is selected
    func drinksSelected()
    {
        self.foodType = "bar"
        performSegue(withIdentifier: "FoodMapSegue", sender: nil)
        
    }
    
        
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "FoodMapSegue")
        {
             let destinationVC: FoodMapViewController = segue.destination as! FoodMapViewController
            //destinationVC.placeArray = self.placeArray
            destinationVC.foodType = self.foodType
            
        }
       
    }
    

}
