//
//  TransportationDetailsViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 5/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class TransportationDetailsViewController: UIViewController {

    @IBOutlet var mykiIcon: UIImageView!
    @IBOutlet var typesIcon: UIImageView!
    @IBOutlet var offersIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        //Adding gesture recognition for myki icon
        let tapGestureRecogniserForMyki = UITapGestureRecognizer(target: self, action:#selector(TransportationDetailsViewController.mykiSelected))
        mykiIcon.isUserInteractionEnabled = true
        mykiIcon.addGestureRecognizer(tapGestureRecogniserForMyki)
        
        //Adding gesture recognition for types icon
        let tapGestureRecogniserForTypes = UITapGestureRecognizer(target: self, action:#selector(TransportationDetailsViewController.typesSelected))
        typesIcon.isUserInteractionEnabled = true
        typesIcon.addGestureRecognizer(tapGestureRecogniserForTypes)
        
        //Adding gesture recognition for offers icon
        let tapGestureRecogniserForOffers = UITapGestureRecognizer(target: self, action:#selector(TransportationDetailsViewController.offersSelected))
        offersIcon.isUserInteractionEnabled = true
        offersIcon.addGestureRecognizer(tapGestureRecogniserForOffers)
        
        // Do any additional setup after loading the view.
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mykiSelected()
    {
        performSegue(withIdentifier: "mykiSegue", sender: nil)
    }
    func typesSelected()
    {
        performSegue(withIdentifier: "publicTransportSegue", sender: nil)
    }
    func offersSelected()
    {
        performSegue(withIdentifier: "freeTramZoneSegue", sender: nil)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mykiSegue")
        {
            let destinationVC: MykiViewController = segue.destination as! MykiViewController
        }
        if(segue.identifier == "publicTransportSegue")
        {
            let destinationMapVC: PtvMapViewController = segue.destination as! PtvMapViewController
        }
        if(segue.identifier == "freeTramZoneSegue")
        {
            let destinationFreeTramVC: PtvWebViewController = segue.destination as! PtvWebViewController
            destinationFreeTramVC.selectedUrl = "https://static.ptv.vic.gov.au/siteassets/PDFs/Maps/Network-maps/PTV-Free-Tram-Zone-Map.pdf"
        }
        
    }
    

}
