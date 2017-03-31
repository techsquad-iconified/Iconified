//
//  FoodPhotoViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 31/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class FoodPhotoViewController: UIViewController {

    @IBOutlet var photoView: UIImageView!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoView.image = self.selectedImage
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
