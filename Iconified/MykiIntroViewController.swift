//
//  MykiIntroViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 7/5/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class MykiIntroViewController: UIViewController {

    @IBOutlet var infoImage: UIImageView!
    @IBOutlet var locationImage: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding gesture recognition for About icon
        let tapGestureRecogniserForAboutMyki = UITapGestureRecognizer(target: self, action:#selector(MykiIntroViewController.aboutMykiSelected))
        infoImage.isUserInteractionEnabled = true
        infoImage.addGestureRecognizer(tapGestureRecogniserForAboutMyki)
        
        //Adding gesture recognition for location icon
        let tapGestureRecogniserForMykiLocation = UITapGestureRecognizer(target: self, action:#selector(MykiIntroViewController.locationSelected))
        locationImage.isUserInteractionEnabled = true
        locationImage.addGestureRecognizer(tapGestureRecogniserForMykiLocation)

        // Do any additional setup after loading the view.
    }

    func aboutMykiSelected()
    {
        performSegue(withIdentifier: "mykiInfoSegue", sender: nil)
    }
    
    func locationSelected()
    {
        performSegue(withIdentifier: "mykiLocationSegue", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mykiInfoSegue")
        {
            let destinationAboutVC: MykiInfoViewController = segue.destination as! MykiInfoViewController
        }
        if(segue.identifier == "mykiLocationSegue")
        {
            let destinationLocationVC: MykiLocationViewController = segue.destination as! MykiLocationViewController
        }
    }
    

}
