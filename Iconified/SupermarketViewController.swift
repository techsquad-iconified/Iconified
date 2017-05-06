

import Foundation//
//  File.swift
//  Iconified
//
//  Created by 张翼扬 on 29/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//
import UIKit

class SupermarketViewController: UIViewController {
    
    //Variabes representing user's location
    var latitude: Double?
    var longitude: Double?
    //Array of places in the particular category
    var placeArray: NSMutableArray
    //Type Accommodation style selected and keyword  by the user
    var marketType: String?
    var keyword: String?
    
    //UI attributes
    
    @IBOutlet weak var supermarketIcon: UIImageView!

    @IBOutlet weak var electronicIcon: UIImageView!
    
    @IBOutlet weak var clothesIcon: UIImageView!
    
    @IBOutlet weak var groceryIcon: UIImageView!
    
    //Intilaliser
    required init?(coder aDecoder: NSCoder) {
        self.latitude = nil
        self.longitude = nil
        self.marketType = nil
        self.keyword = nil
        self.placeArray = NSMutableArray()
        super.init(coder: aDecoder)
    }
    
    //method called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding gesture recognition for supermarketIcon icon
        let tapGestureRecogniserForSupermarket = UITapGestureRecognizer(target: self, action:#selector(SupermarketViewController.SupermarketSelected))
        supermarketIcon.isUserInteractionEnabled = true
        supermarketIcon.addGestureRecognizer(tapGestureRecogniserForSupermarket)
        
        //Adding gesture recognition for electronic icon
        let tapGestureRecogniserForElectronic = UITapGestureRecognizer(target: self, action:#selector(SupermarketViewController.ElectronicSelected))
        electronicIcon.isUserInteractionEnabled = true
        electronicIcon.addGestureRecognizer(tapGestureRecogniserForElectronic)
        
        //Adding gesture recognition for clothes icon
        let tapGestureRecogniserForClothes = UITapGestureRecognizer(target: self, action:#selector(SupermarketViewController.ClothesSelected))
        clothesIcon.isUserInteractionEnabled = true
        clothesIcon.addGestureRecognizer(tapGestureRecogniserForClothes)
        
        //Adding gesture recognition for grocery icon
        let tapGestureRecogniserForGrocery = UITapGestureRecognizer(target: self, action:#selector(SupermarketViewController.GrocerySelected))
        groceryIcon.isUserInteractionEnabled = true
        groceryIcon.addGestureRecognizer(tapGestureRecogniserForGrocery)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Method is called when the supermarket icon is selected
    func SupermarketSelected()
    {
        self.marketType = "grocery_or_supermarket"
        self.keyword = nil
        performSegue(withIdentifier: "SupermarketMapSegue", sender: nil)
        print("supermarket selected")
    }
    
    //method is called when clothes shop icon is selected
    func ClothesSelected()
    {
        self.marketType = "shops"
        self.keyword = "clothes"
        performSegue(withIdentifier: "SupermarketMapSegue", sender: nil)
        print("electronics shop selected")
    }
    
    //method is called when Electronic icon is selected
    func ElectronicSelected()
    {
        //self.downloadLocationData()
        self.marketType = "shops"
        self.keyword = "electronics"
        performSegue(withIdentifier: "SupermarketMapSegue", sender: nil)
        print("Electronic shop selected")
    }
    
    //method is called when grocery icon is selected
    func GrocerySelected()
    {
        self.marketType = "shops"
        self.keyword = "vegetables"
        performSegue(withIdentifier: "SupermarketMapSegue", sender: nil)
        print("grocery selected")
    }
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SupermarketMapSegue")
        {
            let destinationVC: SupermarketMapViewController = segue.destination as! SupermarketMapViewController
            //destinationVC.placeArray = self.placeArray
            destinationVC.marketType = self.marketType
            destinationVC.keyword = self.keyword
            
        }
        
    }
    
    
}
