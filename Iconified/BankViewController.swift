//
//  Supermarket.swift
//  Iconified
//
//  Created by 张翼扬 on 29/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import Foundation//
//  File.swift
//  Iconified
//
//  Created by 张翼扬 on 4/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//
import UIKit

class BankViewController: UIViewController {
    
    //Variabes representing user's location
    var latitude: Double?
    var longitude: Double?
    //Array of places in the particular category
    var placeArray: NSMutableArray
    //Type Accommodation style selected by the user
    var requestType: String?
    
    //UI attributes
    
    @IBOutlet weak var bankIcon: UIImageView!

    @IBOutlet weak var ATMIcon: UIImageView!
    //Intilaliser
    required init?(coder aDecoder: NSCoder) {
        self.latitude = nil
        self.longitude = nil
        self.requestType = nil
        self.placeArray = NSMutableArray()
        super.init(coder: aDecoder)
    }
    
    //method called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding gesture recognition for supermarketIcon icon
        let tapGestureRecogniserForBank = UITapGestureRecognizer(target: self, action:#selector(BankViewController.BankSelected))
        bankIcon.isUserInteractionEnabled = true
        bankIcon.addGestureRecognizer(tapGestureRecogniserForBank)
        
        //Adding gesture recognition for electronic icon
        let tapGestureRecogniserForATM = UITapGestureRecognizer(target: self, action:#selector(BankViewController.ATMSelected))
        ATMIcon.isUserInteractionEnabled = true
        ATMIcon.addGestureRecognizer(tapGestureRecogniserForATM)
        
    
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Method is called when the Bank icon is selected
    func BankSelected()
    {
        self.requestType = "bank"
        performSegue(withIdentifier: "BankMapSegue", sender: nil)
        print("Bank selected")
    }
    
    //method is called when ATM icon is selected
    func ATMSelected()
    {
        //self.downloadLocationData()
        self.requestType = "atm"
        performSegue(withIdentifier: "BankMapSegue", sender: nil)
        print("ATM selected")
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "BankMapSegue")
        {
            let destinationVC: BankMapViewController = segue.destination as! BankMapViewController
            //destinationVC.placeArray = self.placeArray
            destinationVC.requestType = self.requestType
            
        }
        
    }
    
    
}
