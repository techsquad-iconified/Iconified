//
//  EmergenyDetailViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 21/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class EmergenyDetailViewController: UIViewController, emegencyAboutViewDelegate, emerencyPhotoViewDelegate {

    //The place selected by the user
    var selectedPlace: Hospital
    var gpSelected: Bool?
    var selectedUrl: String?
    
    //UI variables
    @IBOutlet var detailSegment: UISegmentedControl!
    @IBOutlet var aboutContainer: UIView!
    @IBOutlet var photosContainer: UIView!
    @IBOutlet var bannerImage: UIImageView!
    
    //Image selected from the gallery
    var selectedImageIndex: Int?
    //Array of photos of the place
    var photoArray = [UIImage]()
    //Type of browsing required - website or google directions
    var browseType: String?
    
    //Initialiser
    required init?(coder aDecoder: NSCoder) {
        self.selectedPlace = Hospital()
        self.browseType = nil
        if(gpSelected == nil)
        {
            gpSelected = false
        }
        super.init(coder: aDecoder)
    }
    
    //Function called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        //About container is displayed by default
        aboutContainer.isHidden = false
        photosContainer.isHidden = true
        if(self.gpSelected! == true)
        {
            self.detailSegment.selectedSegmentIndex = 0
            self.detailSegment.removeSegment(at: 1, animated: true)
        }
        if(self.selectedPlace.photoReference.count == 0)
        {
            self.detailSegment.selectedSegmentIndex = 0
            self.detailSegment.removeSegment(at: 1, animated: true)
        }
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        //set page title
        self.title = self.selectedPlace.name
        //set banner image
        if(self.selectedPlace.firstPhoto.size == CGSize(width: 0.0, height: 0.0))
        {
            self.bannerImage.image = UIImage(named: "Default")
        }
        else
        {
            self.bannerImage.image = self.selectedPlace.firstPhoto
        }
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Funtioned called when an change in segment is performed
    @IBAction func segmentAction(_ sender: UISegmentedControl)
    {
        
        switch sender.selectedSegmentIndex
        {
        case 0 : aboutContainer.isHidden = false    //view details
                 photosContainer.isHidden = true
        case 1:  aboutContainer.isHidden = true     //view photos
                 photosContainer.isHidden = false
        default: break;
        }
        
        
    }
    
    //Generate segue for browsing
    func generateSegue(type: String)
    {
        print("segue returned \(type)")
        self.browseType = type
        performSegue(withIdentifier: "webViewSegue", sender: nil)
        
    }
    
    //Segue for viewing photos
    func photoSegue(selectedImageIndex: Int, photoArray: [UIImage])
    {
        self.selectedImageIndex = selectedImageIndex
        self.photoArray = photoArray
        performSegue(withIdentifier: "photoViewSegue", sender: nil)
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //segue for about container
        if segue.identifier == "aboutSegue" {
            let aboutView = (segue.destination as? EmergencyAboutViewController)!
            aboutView.selectedPlace = self.selectedPlace
            aboutView.delegate = self
        }
        
        //segue for photo container
        if segue.identifier == "photoAlbumSegue" {
            let photoView = (segue.destination as? EmergencyPhotoAlbumViewController)!
            photoView.selectedPlace = self.selectedPlace
            photoView.delegate = self
        }
        
        ///segue for browsing
        if segue.identifier == "webViewSegue" {
            let webView = (segue.destination as? EmergencyWebViewController)!
            webView.selectedPlace = self.selectedPlace
            webView.type = self.browseType
            // containerViewController!.containerToMaster = self
        }
        
         //segue for photo slide show
        if(segue.identifier == "photoViewSegue")
        {
            let destinationVC: PhotoViewController = segue.destination as! PhotoViewController
            destinationVC.imageArray = self.photoArray
            destinationVC.selectedImageIndex = self.selectedImageIndex
        }
 
        
        
    }


}
