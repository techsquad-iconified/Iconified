//
//  MenuViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 29/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

/* 
 The View Controller is linked to the main screen of the application
 It conists of a radial menu of icons representing various facilities in the application
 On selecting a specific facility, the user is redirected to the faclity page

 */

import UIKit

class MenuViewController: UIViewController {

    //A start button to represent click on the screen
    let startButton = UIButton()
    //Initialising the Radial menu item
    var menu = ALRadialMenu()
    
    //Method to initialise teh screen when it loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //  let gesture = UITapGestureRecognizer(target: self, action: #selector(showMenu(sender:)))
        //view.addGestureRecognizer(gesture)
        view.backgroundColor = UIColor.white
       // self.showMenu()
        self.startButtonSelected(sender: self.view)
        
        /*
        //Adding gesture recognition for start icon
        let tapGestureRecogniserForStart = UITapGestureRecognizer(target: self, action:#selector(MenuViewController.startButtonSelected))
        startButton.isUserInteractionEnabled = true
        startButton.addGestureRecognizer(tapGestureRecogniserForStart)
        //startButton.setTitle("Press", for: UIControlState.normal)
        
        //settings for the start button
        startButton.sizeToFit()
        startButton.setImage(UIImage(named: "start"), for: UIControlState.normal)
        startButton.frame.size.height = 70
        startButton.frame.size.width = 60
        startButton.center = view.center
        view.addSubview(startButton)
        startButton.sendActions(for: .touchUpInside)
        */
    }
    
    //This function is called when the start method is clicked
    func startButtonSelected(sender: UIView) {
        _ = ALRadialMenu()
            .setButtons(buttons: generateButtons())
            .setDelay(delay: 0.05)
            .setAnimationOrigin(animationOrigin: sender.center)
            .presentInView(view: view)
    }
    
    //Method to generate an array of ALRadialMenuButtons representing various facilities
    func generateButtons() -> [ALRadialMenuButton] {
        
        var buttons = [ALRadialMenuButton]()
        
        //Initialising the icon for Food Feature
        let foodIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        foodIcon.setImage(UIImage(named: "Food"), for: UIControlState.normal)
        foodIcon.frame.size.height = 90
        foodIcon.frame.size.width = 90
        
        //Adding gesture recognition for start icon
        let tapGestureRecogniserForFood = UITapGestureRecognizer(target: self, action:#selector(MenuViewController.foodIconSelected))
        foodIcon.isUserInteractionEnabled = true
        foodIcon.addGestureRecognizer(tapGestureRecogniserForFood)
        
        //Initialising the icon for transportation Feature
        let transportIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        transportIcon.setImage(UIImage(named: "Transportation"), for: UIControlState.normal)
        transportIcon.frame.size.height = 90
        transportIcon.frame.size.width = 90
        
        //Initialising the icon for Accommodation Feature
        let AccommodationIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        AccommodationIcon.setImage(UIImage(named: "Accommodation"), for: UIControlState.normal)
        AccommodationIcon.frame.size.height = 90
        AccommodationIcon.frame.size.width = 90
        
        //Initialising the icon for Banking Feature
        let BankingIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        BankingIcon.setImage(UIImage(named: "Banking"), for: UIControlState.normal)
        BankingIcon.frame.size.height = 90
        BankingIcon.frame.size.width = 90
        
        //Initialising the icon for Shopping Feature
        let ShoppingIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        ShoppingIcon.setImage(UIImage(named: "Shopping"), for: UIControlState.normal)
        ShoppingIcon.frame.size.height = 90
        ShoppingIcon.frame.size.width = 90
        
        //Initialising the icon for Emergency Feature
        let EmergencyIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        EmergencyIcon.setImage(UIImage(named: "Emergency"), for: UIControlState.normal)
        EmergencyIcon.frame.size.height = 90
        EmergencyIcon.frame.size.width = 90
        
        //Appending the icons to the array
        buttons.append(foodIcon)
        buttons.append(transportIcon)
        buttons.append(AccommodationIcon)
        buttons.append(BankingIcon)
        buttons.append(ShoppingIcon)
        buttons.append(EmergencyIcon)
        /*
        for i in 0..<6 {
            let button = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            button.setImage(UIImage(named: "icon"), for: UIControlState.normal)
            buttons.append(button)
        }
        */
        
        return buttons
    }
    
    //Method is called when the food icon is selected
    func foodIconSelected(sender: UIGestureRecognizer) {
        print("Food selected")
        performSegue(withIdentifier: "FoodMainSegue", sender: nil)
    }
    
    
    // MARK: - Navigation
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue to Food page
        if(segue.identifier == "FoodMainSegue")
        {
            let destinationFoodVC: FoodViewController = segue.destination as! FoodViewController
            
            
        }
    }
    
    //Method to create and poulate Radial Menu on screen
    func showMenu(sender: UIGestureRecognizer) {
        menu.setButtons(buttons: generateButtons())
            .setDelay(delay: 0.05)
            .setAnimationOrigin(animationOrigin: sender.location(in: view))
            .presentInView(view: view)
            .center = view.center
    }

}
