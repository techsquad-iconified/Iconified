//
//  TrialViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 26/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class TrialViewController: UIViewController {

    @IBOutlet var containerOne: UIView!
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var containerTwo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerOne.isHidden = false
        containerTwo.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func SegmentAtion(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0 : containerOne.isHidden = false
                 containerTwo.isHidden = true
        case 1: containerOne.isHidden = true
                containerTwo.isHidden = false
        default: break;
        }

        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
