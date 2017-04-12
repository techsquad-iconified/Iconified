//
//  FoodAboutViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 27/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

protocol aboutViewDelegate {
    func generateSegue(type: String)
}
/*
 View controller representing the details about the place selected by the user.
 The view is embedded into a container in the details page.
 */

import UIKit

class FoodAboutViewController: UIViewController {

    //UI Variables
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var websiteLabel: UILabel!
    @IBOutlet var priceLevelUnavailable: UILabel!
    @IBOutlet var ratingUnavailable: UILabel!
    
    @IBOutlet var ratingOne: UIImageView!
    @IBOutlet var ratingTwo: UIImageView!
    @IBOutlet var ratingThree: UIImageView!
    @IBOutlet var ratingFive: UIImageView!
    @IBOutlet var ratingFour: UIImageView!
    
    @IBOutlet var coinOne: UIImageView!
    @IBOutlet var coinTwo: UIImageView!
    @IBOutlet var coinThree: UIImageView!
    @IBOutlet var coinFour: UIImageView!
    @IBOutlet var coinFive: UIImageView!
    
    @IBOutlet var navigationIcon: UIImageView!
    @IBOutlet var callIcon: UIImageView!
    
    //The plae object of the selected place
    var selectedPlace: Place?
    //delegate
    var delegate: aboutViewDelegate?
    
    //Images used to represent the rating of the place
    let fullStarImage:  UIImage = UIImage(named: "Star Full")!
    let halfStarImage:  UIImage = UIImage(named: "Star Half")!
    let emptyStarImage: UIImage = UIImage(named: "Star Grey")!
    
    //Images used to represent price level of the place
    let cheapImage: UIImage = UIImage(named: "Cheapest")!
    let cheapGreyImage: UIImage = UIImage(named: "Cheapest Grey")!
    
    let leastExpensiveImage: UIImage = UIImage(named: "Least Expensive")!
    let leastExpensiveGreyImage: UIImage = UIImage(named: "Least Expensive Grey")!
    
    let intermediateExpensiveImage: UIImage = UIImage(named: "Intermediate Expensive")!
    let intermediateExpensiveGreyImage: UIImage = UIImage(named: "Intermediate Expensive Grey")!
    
    let expensiveImage: UIImage = UIImage(named: "Expensive")!
    let expensiveGreyImage: UIImage = UIImage(named: "Expensive Grey")!
    
    let veryExpensiveImage: UIImage = UIImage(named: "Very Expensive")!
    let veryExpensiveGreyImage: UIImage = UIImage(named: "Very Expensive Grey")!
  
    //method called when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        //Adding gesture recognition for navigation icon
        let tapGestureRecogniserForNavigation = UITapGestureRecognizer(target: self, action:#selector(FoodAboutViewController.navigationIconSelected))
        navigationIcon.isUserInteractionEnabled = true
        navigationIcon.addGestureRecognizer(tapGestureRecogniserForNavigation)
        
        //Adding gesture recognition for website label
        let tapGestureRecogniserForWebsite = UITapGestureRecognizer(target: self, action:#selector(FoodAboutViewController.websiteSelected))
        websiteLabel.isUserInteractionEnabled = true
        websiteLabel.addGestureRecognizer(tapGestureRecogniserForWebsite)
        
        //Adding gesture recognition for call icon
        let tapGestureRecogniserForCall = UITapGestureRecognizer(target: self, action:#selector(FoodAboutViewController.callSelected))
        callIcon.isUserInteractionEnabled = true
        callIcon.addGestureRecognizer(tapGestureRecogniserForCall)
        
        //Update values for the labels
        self.updateLabels()

        // Do any additional setup after loading the view.
    }

    override open var shouldAutorotate: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //methods loads all details of the place
    func updateLabels()
    {
        if(self.selectedPlace?.placeAddress != nil)
        {
            self.addressLabel.text = self.selectedPlace?.placeAddress
        }
        else
        {
            self.addressLabel.textColor = UIColor.gray
        }
        
        if(self.selectedPlace?.phoneNumber != nil)
        {
            self.phoneLabel.text = self.selectedPlace?.phoneNumber
        }
        else
        {
            self.phoneLabel.textColor = UIColor.gray
        }
        
        if(self.selectedPlace?.website != nil)
        {
            self.websiteLabel.text = self.selectedPlace?.website
        }
        else
        {
            self.websiteLabel.textColor = UIColor.gray
        }
        self.getPriceLevel()
        self.getRating()
        
    }
    
    //Funtion displays the rating of teh place using images of stars
    func getRating()
    {
        if(self.selectedPlace?.rating != nil)
        {
            if let ourRating = self.selectedPlace?.rating
            {
                self.ratingOne.image = getStarImage(starNumber: 1, forRating: ourRating)
                self.ratingTwo.image = getStarImage(starNumber: 2, forRating: ourRating)
                self.ratingThree.image = getStarImage(starNumber: 3, forRating: ourRating)
                self.ratingFour.image = getStarImage(starNumber: 4, forRating: ourRating)
                self.ratingFive.image = getStarImage(starNumber: 5, forRating: ourRating)
            }
        }
        else
        {
            //If rating data is missing - inform the user as "unavailable"
            self.ratingUnavailable.tintColor = UIColor.gray
            self.ratingUnavailable.text = "Unavailable"
        
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
    
    //Funtion displays the rating of teh place using images of dollar coins
    func getPriceLevel()
    {
       if(self.selectedPlace?.priceLevel != nil)
       {
        let pricelevel: Int = (self.selectedPlace?.priceLevel)!
            switch pricelevel
            {
            case 0: self.coinOne.image = cheapImage
                    self.coinTwo.image = leastExpensiveGreyImage
                    self.coinThree.image = intermediateExpensiveGreyImage
                    self.coinFour.image = expensiveGreyImage
                    self.coinFive.image = veryExpensiveGreyImage
            case 1: self.coinOne.image = cheapImage
                    self.coinTwo.image = leastExpensiveImage
                    self.coinThree.image = intermediateExpensiveGreyImage
                    self.coinFour.image = expensiveGreyImage
                    self.coinFive.image = veryExpensiveGreyImage
            case 2: self.coinOne.image = cheapImage
                    self.coinTwo.image = leastExpensiveImage
                    self.coinThree.image = intermediateExpensiveImage
                    self.coinFour.image = expensiveGreyImage
                    self.coinFive.image = veryExpensiveGreyImage
            case 3: self.coinOne.image = cheapImage
                    self.coinTwo.image = leastExpensiveImage
                    self.coinThree.image = intermediateExpensiveImage
                    self.coinFour.image = expensiveImage
                    self.coinFive.image = veryExpensiveGreyImage
            case 4: self.coinOne.image = cheapImage
                    self.coinTwo.image = leastExpensiveImage
                    self.coinThree.image = intermediateExpensiveImage
                    self.coinFour.image = intermediateExpensiveImage
                    self.coinFive.image = veryExpensiveImage
            default: break
            }

        }
        else
        {
            self.priceLevelUnavailable.tintColor = UIColor.gray
            self.priceLevelUnavailable.text = "Unavailable"
            
            /*
            self.coinOne.image = cheapGreyImage
            self.coinTwo.image = leastExpensiveGreyImage
            self.coinThree.image = intermediateExpensiveGreyImage
            self.coinFour.image = expensiveGreyImage
            self.coinFive.image = veryExpensiveGreyImage
            */
        
        }
    }
    
    //Funtion called when navigation is selected
    func navigationIconSelected()
    {
        print("Navigation was clicked.")
        if(self.selectedPlace?.url != nil)
        {
            delegate?.generateSegue(type: "navigation") // calls the delegate method of the container view
        }
        
    }
    //Funtion called when website is selected
    func websiteSelected()
    {
        if(self.selectedPlace?.website != nil)
        {
            delegate?.generateSegue(type: "website")   // calls the delegate method of the container view
        }
    }
    //Funtion called when call icon is selected
    func callSelected()
    {
        print("phone number is \((self.selectedPlace?.phoneNumber!)!)")
        let phoneString: String = (self.selectedPlace?.phoneNumber!)!
        let firstString = phoneString.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
        let secondString = firstString.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        let finalString = secondString.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        print("final string is \(finalString)")
        if let url = URL(string: "telprompt://\(finalString)") {
            UIApplication.shared.openURL(url)
        }
    }
}
