//
//  MykiViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 6/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class MykiViewController: UIViewController {

    var selectedUrl: String?
    
    @IBOutlet var mykiStoreLocations: UIImageView!
    @IBOutlet var buyMyki: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Adding gesture recognition for offers icon
        let tapGestureRecogniserForMykiStore = UITapGestureRecognizer(target: self, action:#selector(MykiViewController.findMykiStoreSelected))
        mykiStoreLocations.isUserInteractionEnabled = true
        mykiStoreLocations.addGestureRecognizer(tapGestureRecogniserForMykiStore)
       
        
        //Adding gesture recognition for offers icon
        let tapGestureRecogniserForBuyMyki = UITapGestureRecognizer(target: self, action:#selector(MykiViewController.buyMykiSelected))
        buyMyki.isUserInteractionEnabled = true
        buyMyki.addGestureRecognizer(tapGestureRecogniserForBuyMyki)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

    @IBAction func studentOfferButton(_ sender: Any) {
        self.selectedUrl = "https://www.ptv.vic.gov.au/tickets/fares/concession/tertiary-students/international-students/"
        performSegue(withIdentifier: "mykiWebViewSegue", sender: nil)
        
    }
    
    func findMykiStoreSelected()
    {
        self.selectedUrl = "https://www.ptv.vic.gov.au/tickets/myki/ef1d0f60a/buying-your-myki/widget/149/showmap/"
        performSegue(withIdentifier: "mykiWebViewSegue", sender: nil)
        
    }
    
    func buyMykiSelected()
    {
        self.selectedUrl = "https://www.ptv.vic.gov.au/tickets/myki/buy-a-myki/"
        performSegue(withIdentifier: "mykiWebViewSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mykiWebViewSegue")
        {
            let destinationVC : PtvWebViewController = segue.destination as! PtvWebViewController
            destinationVC.selectedUrl = self.selectedUrl!
        }
    }
    

}
