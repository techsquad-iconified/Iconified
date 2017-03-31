//
//  FoodDetailViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 25/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class FoodDetailViewController: UIViewController, aboutViewDelegate, photoViewDelegate {
    
    var selectedPlace: Place
 
    @IBOutlet var detailSegment: UISegmentedControl!
    @IBOutlet var aboutContainer: UIView!
    @IBOutlet var photosContainer: UIView!
    @IBOutlet var bannerImage: UIImageView!
    
    var selectedImage: UIImage?
    var photoArray = [UIImage]()
    var browseType: String?
    
    required init?(coder aDecoder: NSCoder) {
        self.selectedPlace = Place()
        self.browseType = nil
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        aboutContainer.isHidden = false
        photosContainer.isHidden = true
        self.title = self.selectedPlace.placeName
        //performSegue(withIdentifier: "aboutSegue", sender: nil)
        self.bannerImage.image = self.selectedPlace.firstPhoto
        
        print("In detail view \(selectedPlace.placeName!)")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func segmentAction(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
        case 0 : aboutContainer.isHidden = false
                 photosContainer.isHidden = true
                 //performSegue(withIdentifier: "aboutSegue", sender: nil)
        case 1:  aboutContainer.isHidden = true
                 photosContainer.isHidden = false
        default: break;
        }
    
    
    }
    
    func generateSegue(type: String)
    {
        print("segue returned \(type)")
        self.browseType = type
        performSegue(withIdentifier: "webViewSegue", sender: nil)
    }
    
    func photoSegue(selectedImage: UIImage, photoArray: [UIImage])
    {
        self.selectedImage = selectedImage
        self.photoArray = photoArray
        performSegue(withIdentifier: "trialSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "aboutSegue" {
             let aboutView = (segue.destination as? FoodAboutViewController)!
            aboutView.selectedPlace = self.selectedPlace
            aboutView.delegate = self
        }
        
        if segue.identifier == "photoAlbumSegue" {
            let photoView = (segue.destination as? FoodPhotoAlbumViewController)!
            photoView.selectedPlace = self.selectedPlace
            photoView.delegate = self
        }
        
        if segue.identifier == "webViewSegue" {
            let webView = (segue.destination as? WebViewController)!
            webView.selectedPlace = self.selectedPlace
            webView.type = self.browseType
            // containerViewController!.containerToMaster = self
        }
        
        if(segue.identifier == "photoViewSegue")
        {
            let destinationVC: FoodPhotoViewController = segue.destination as! FoodPhotoViewController
            destinationVC.selectedImage = self.selectedImage
        }
        if(segue.identifier == "trialSegue")
        {
            let destinationVC: PhotoViewController = segue.destination as! PhotoViewController
            destinationVC.imageArray = self.photoArray
            destinationVC.selectedImage = self.selectedImage
        }
        
        
    }
    

}
