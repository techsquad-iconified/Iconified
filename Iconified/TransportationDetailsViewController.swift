//
//  TransportationDetailsViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 5/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//
/*
 TransportationDetailsViewController is a view controller that displays the details of traansportation feature to the users
 It allows the users to select between the facilities provided
 */


import UIKit
class TransportationDetailsViewController: UIViewController {

    //UI Variables
    @IBOutlet var mykiIcon: UIImageView!
    @IBOutlet var typesIcon: UIImageView!
    
    //Method called when the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()

        //Adding gesture recognition for myki icon
        let tapGestureRecogniserForMyki = UITapGestureRecognizer(target: self, action:#selector(TransportationDetailsViewController.mykiSelected))
        mykiIcon.isUserInteractionEnabled = true
        mykiIcon.addGestureRecognizer(tapGestureRecogniserForMyki)
        
        //Adding gesture recognition for types icon
        let tapGestureRecogniserForTypes = UITapGestureRecognizer(target: self, action:#selector(TransportationDetailsViewController.typesSelected))
        typesIcon.isUserInteractionEnabled = true
        typesIcon.addGestureRecognizer(tapGestureRecogniserForTypes)
       
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Method called when Myki icon is selected
    func mykiSelected()
    {
        //performSegue(withIdentifier: "mykiSegue", sender: nil)
        performSegue(withIdentifier: "mykiIntroSegue", sender: nil)
    }
    
    //Method called when public transport types is selected
    func typesSelected()
    {
        performSegue(withIdentifier: "publicTransportSegue", sender: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Segue to details on myki
        if(segue.identifier == "mykiIntroSegue")
        {
            let destinationVC: MykiIntroViewController = segue.destination as! MykiIntroViewController
        }
        //Segue to public transport
        if(segue.identifier == "publicTransportSegue")
        {
            let destinationMapVC: PtvMapViewController = segue.destination as! PtvMapViewController
        }
        /*
         //Segue to free tram zone
        if(segue.identifier == "freeTramZoneSegue")
        {
            let destinationFreeTramVC: PtvWebViewController = segue.destination as! PtvWebViewController
            destinationFreeTramVC.selectedUrl = "https://static.ptv.vic.gov.au/siteassets/PDFs/Maps/Network-maps/PTV-Free-Tram-Zone-Map.pdf"
        }
         */
        
    }
    

}
