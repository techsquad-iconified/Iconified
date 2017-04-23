//
//  PhotoViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 31/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

/* 
 The view controller represents the photo slideshow of the selecte image from the gallery
 */
import UIKit
class PhotoViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    //UI component
    @IBOutlet var displayView: iCarousel!
    var imageArray = [UIImage]()
    var selectedImageIndex: Int?
    var newArray = [UIImage]()
    
    //Function called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting display type of slide show
        self.displayView.type = iCarouselType.invertedCylinder
        //Setting index to the selected item
        self.displayView.currentItemIndex = self.selectedImageIndex!
        self.displayView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func reArrangeArray()
    {
        var i: Int =  self.selectedImageIndex!
        self.newArray.append(imageArray[i])
        
    }
    
   
    
    //Function to load images into the slide show
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var imageView: UIImageView!
        
        if(view == nil)
        {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
            imageView.contentMode = .scaleAspectFit
        }
        else
        {
            imageView = view as! UIImageView
        }
        imageView.image = self.imageArray[index]
        return imageView
    
    }

    //Represents the number of images present
    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.imageArray.count
    }
    //function used to resize the images retrieved
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
          
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            //CGRect(x: 0,y: 0, width: newSize.width,heigth: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        //drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
   

}
