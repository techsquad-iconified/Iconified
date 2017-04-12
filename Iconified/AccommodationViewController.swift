//
//  File.swift
//  Iconified
//
//  Created by 张翼扬 on 4/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//
import UIKit

class AccommodationViewController: UIViewController {
    
    //Variabes representing user's location
    var latitude: Double?
    var longitude: Double?
    //Array of places in the particular category
    var placeArray: NSMutableArray
    //Type Accommodation style selected by the user
    var accommodationType: String?
    
    //UI attributes

    @IBOutlet weak var HotelIcon: UIImageView!
    @IBOutlet weak var MotelIcon: UIImageView!

 
    
    //Intilaliser
    required init?(coder aDecoder: NSCoder) {
        self.latitude = nil
        self.longitude = nil
        self.accommodationType = nil
        self.placeArray = NSMutableArray()
        super.init(coder: aDecoder)
    }
    
    //method called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding gesture recognition for Hotel icon
        let tapGestureRecogniserForHotel = UITapGestureRecognizer(target: self, action:#selector(AccommodationViewController.HotelSelected))
        HotelIcon.isUserInteractionEnabled = true
        HotelIcon.addGestureRecognizer(tapGestureRecogniserForHotel)
        
        //Adding gesture recognition for Motel icon
        let tapGestureRecogniserForMotel = UITapGestureRecognizer(target: self, action:#selector(AccommodationViewController.MotelSelected))
        MotelIcon.isUserInteractionEnabled = true
        MotelIcon.addGestureRecognizer(tapGestureRecogniserForMotel)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Method is called when the Hotel icon is selected
    func HotelSelected()
    {
        self.accommodationType = "lodging"
        performSegue(withIdentifier: "AccommodationMapSegue", sender: nil)
        print("Hotel selected")
    }
    
    //method is called when Motel icon is selected
    func MotelSelected()
    {
        //self.downloadLocationData()
        self.accommodationType = "real_estate_agency"
        performSegue(withIdentifier: "AccommodationMapSegue", sender: nil)
        print("Real_Estate_Agency selected")
    }
    

    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AccommodationMapSegue")
        {
            let destinationVC: AccommodationMapViewController = segue.destination as! AccommodationMapViewController
            //destinationVC.placeArray = self.placeArray
            destinationVC.accommodationType = self.accommodationType
            
        }
        
    }
    
    
}
