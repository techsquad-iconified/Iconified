//
//  MenuViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 29/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    let startButton = UIButton()
    var menu = ALRadialMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //  let gesture = UITapGestureRecognizer(target: self, action: #selector(showMenu(sender:)))
        //view.addGestureRecognizer(gesture)
        view.backgroundColor = UIColor.white
        
        //Adding gesture recognition for start icon
        let tapGestureRecogniserForStart = UITapGestureRecognizer(target: self, action:#selector(MenuViewController.startButtonSelected))
        startButton.isUserInteractionEnabled = true
        startButton.addGestureRecognizer(tapGestureRecogniserForStart)
        
        startButton.setTitle("Press", for: UIControlState.normal)
       
        startButton.sizeToFit()
        //startButton.backgroundColor = UIColor.red
        
        startButton.setImage(UIImage(named: "start"), for: UIControlState.normal)
        startButton.frame.size.height = 70
        startButton.frame.size.width = 60
        startButton.center = view.center
        view.addSubview(startButton)
        startButton.sendActions(for: .touchUpInside)
    }
    
    func startButtonSelected(sender: UITapGestureRecognizer) {
        _ = ALRadialMenu()
            .setButtons(buttons: generateButtons())
            .setDelay(delay: 0.05)
            .setAnimationOrigin(animationOrigin: sender.location(in: view))
            .presentInView(view: view)
        
        view.tag = 1000
        
        
        
    }
    
    func generateButtons() -> [ALRadialMenuButton] {
        
        var buttons = [ALRadialMenuButton]()
        
        let foodIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        foodIcon.setImage(UIImage(named: "Food"), for: UIControlState.normal)
        foodIcon.frame.size.height = 90
        foodIcon.frame.size.width = 90
        
       
        //Adding gesture recognition for start icon
        let tapGestureRecogniserForFood = UITapGestureRecognizer(target: self, action:#selector(MenuViewController.foodIconSelected))
        foodIcon.isUserInteractionEnabled = true
        foodIcon.addGestureRecognizer(tapGestureRecogniserForFood)
        
        let transportIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        transportIcon.setImage(UIImage(named: "Transport"), for: UIControlState.normal)
        transportIcon.frame.size.height = 90
        transportIcon.frame.size.width = 90
        
        let AccommodationIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        AccommodationIcon.setImage(UIImage(named: "Accommodation"), for: UIControlState.normal)
        AccommodationIcon.frame.size.height = 90
        AccommodationIcon.frame.size.width = 90
        
        let BankingIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        BankingIcon.setImage(UIImage(named: "Banking"), for: UIControlState.normal)
        BankingIcon.frame.size.height = 90
        BankingIcon.frame.size.width = 90
        
        let ShoppingIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        ShoppingIcon.setImage(UIImage(named: "Shopping"), for: UIControlState.normal)
        ShoppingIcon.frame.size.height = 90
        ShoppingIcon.frame.size.width = 90
        
        let EmergencyIcon = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        EmergencyIcon.setImage(UIImage(named: "Emergency"), for: UIControlState.normal)
        EmergencyIcon.frame.size.height = 90
        EmergencyIcon.frame.size.width = 90
        
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
    
    
    func foodIconSelected(sender: UIGestureRecognizer) {
        print("Food selected")
        performSegue(withIdentifier: "FoodMainSegue", sender: nil)
        
        
    }
    
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
    
    
    
    // MARK: - Navigation
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "TransportationSegue")
        {
            let destinationTransportationVC:TransportationViewController = segue.destination as! TransportationViewController
            
        }
        if(segue.identifier == "FoodMainSegue")
        {
            let destinationFoodVC: FoodViewController = segue.destination as! FoodViewController
            
            
        }
    }
    
    func showMenu(sender: UITapGestureRecognizer) {
        menu.setButtons(buttons: generateButtons())
            .setDelay(delay: 0.05)
            .setAnimationOrigin(animationOrigin: sender.location(in: view))
            .presentInView(view: view)
            .center = view.center
        
        /*
        _ = ALRadialMenu()
            .setButtons(buttons: generateButtons())
            .setDelay(delay: 0.05)
            .setAnimationOrigin(animationOrigin: sender.location(in: view))
            .presentInView(view: view)
             .center = view.center
    
 */
    }

}
