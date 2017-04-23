//
//  EmergencyViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 20/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//
/*
 EmergencyViewController is a view controller to the view controller displaying the options for emergency services
 */
import UIKit

class EmergencyViewController: UIViewController {

    
    @IBOutlet var hospitalIcon: UIImageView!
    @IBOutlet var policeIcon: UIImageView!
    
    @IBOutlet var emergencyCallIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding gesture recognition for Hospital icon
        let tapGestureRecogniserForHospital = UITapGestureRecognizer(target: self, action:#selector(EmergencyViewController.hospitalSelected))
        hospitalIcon.isUserInteractionEnabled = true
        hospitalIcon.addGestureRecognizer(tapGestureRecogniserForHospital)
        
        //Adding gesture recognition for Police icon
        let tapGestureRecogniserForPolice = UITapGestureRecognizer(target: self, action:#selector(EmergencyViewController.policeSelected))
        policeIcon.isUserInteractionEnabled = true
        policeIcon.addGestureRecognizer(tapGestureRecogniserForPolice)
        
        //Adding gesture recognition for emergency call icon
        let tapGestureRecogniserForCall = UITapGestureRecognizer(target: self, action:#selector(EmergencyViewController.callSelected))
        emergencyCallIcon.isUserInteractionEnabled = true
        emergencyCallIcon.addGestureRecognizer(tapGestureRecogniserForCall)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    //Method called when hospital selected
    func hospitalSelected()
    {
        performSegue(withIdentifier: "hospitalSegue", sender: nil)
    }
    //Method called when police selected
    func policeSelected()
    {
        performSegue(withIdentifier: "policeSegue", sender: nil)
    }
    
    //Funtion called when call icon is selected
    func callSelected()
    {
        if let url = URL(string: "telprompt://000") {
            UIApplication.shared.openURL(url)
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
