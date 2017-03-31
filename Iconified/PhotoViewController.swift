//
//  PhotoViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 31/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet var displayView: iCarousel!
    var imageArray = [UIImage]()
    var selectedImage: UIImage?
    var resizedImageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for eachImage in self.imageArray
        {
            self.resizedImageArray.append(self.resizeImage(image: eachImage, targetSize: CGSize(width: 350, height: 350)))
        }
        
        self.displayView.type = iCarouselType.invertedCylinder
        
        self.displayView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        imageView.image = self.resizedImageArray[index]
        return imageView
    
    }

    func numberOfItems(in carousel: iCarousel) -> Int {
        return self.imageArray.count
    }
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
