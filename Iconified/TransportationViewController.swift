//
//  TransportationViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 21/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class TransportationViewController: UIViewController {

    @IBOutlet var detailsIcon: UIImageView!
    @IBOutlet var typesIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding gesture recognition for transportation detaisl icon
        let tapGestureRecogniserForDetails = UITapGestureRecognizer(target: self, action:#selector(TransportationViewController.detailsSelected))
        detailsIcon.isUserInteractionEnabled = true
        detailsIcon.addGestureRecognizer(tapGestureRecogniserForDetails)

        //Adding gesture recognition for close by commute icon
        let tapGestureRecogniserForCommute = UITapGestureRecognizer(target: self, action:#selector(TransportationViewController.commuteSelected))
        typesIcon.isUserInteractionEnabled = true
        typesIcon.addGestureRecognizer(tapGestureRecogniserForCommute)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func detailsSelected()
    {
        performSegue(withIdentifier: "transportationInfoSegue", sender: nil)
    }
    
    func commuteSelected()
    {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "transportationInfoSegue")
        {
            let destinationVC: TransportationDetailsViewController = segue.destination as! TransportationDetailsViewController
        }
    }


}
