//
//  SupermarketAlbum.swift
//  Iconified
//
//  Created by 张翼扬 on 3/5/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

protocol sphotoViewDelegate {
    func photoSegue(selectedImageIndex: Int, photoArray: [UIImage])
}

import UIKit

class SupermarketPhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //UI collectionview for gallery
    @IBOutlet var photoCollectionView: UICollectionView!
    
    //Global variables
    var selectedPlace: Market?
    var photoReferenceArray = [String]()
    var photoArray = [UIImage]()
    var seletedImage: UIImage?
    var delegate: sphotoViewDelegate?
    
    // creating a view to display a progress spinner while data is being loaded from the server
    var progressView = UIView()
    
    //Method called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoReferenceArray = (self.selectedPlace?.photoReference)!
        
        // setting up the progress view
        setProgressView()
        self.view.addSubview(self.progressView)
        
        print("photo reference array size is \(self.photoReferenceArray.count)")
        // DispatchQueue.main.async(){
        self.getphotos()
        //}
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Method to retrieve the photos based on the reference usng googele places photos
    func getphotos()
    {
        DispatchQueue.main.async(){
            for reference in self.photoReferenceArray
            {
                let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=350&maxheight=350&photoreference=\(reference)&key=AIzaSyAMW8Z_cdUbbVMMviRfe845JBj7xbKhRp4")!
                print(url)
                let data = NSData(contentsOf:url as URL)
                if(data != nil)
                {
                    print("Photo was not nil")
                    //newPlace.firstPhoto = UIImage(data:data! as Data)!
                    self.photoArray.append(UIImage(data:data! as Data)!)
                    print("Array is \(self.photoArray.count)")
                    
                }
                
            }
            self.stopProgressView()
            self.photoCollectionView.reloadData()
        }
        
    }
    
    //UICollectionViewDataSource Methods
    
    //Method represents the number of images in the collection view
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.photoArray.count
    }
    
    //funtion used to load images to the collection view
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: FoodPhotoCollectionViewCell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifier, for: indexPath) as! FoodPhotoCollectionViewCell
        // cell.backgroundColor = UIColor.red
        print("Shishira")
        let placeImage: UIImage = self.photoArray[indexPath.row] as! UIImage
        cell.photoImageView.image = placeImage
        
        return cell
        
    }
    //method is called when am image is selected
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.seletedImage = self.photoArray[indexPath.row]
        self.delegate?.photoSegue(selectedImageIndex: indexPath.row ,photoArray: self.photoArray)
        print("Image selected is at index \(indexPath.row)")
    }
    
    /*
     Setting up the progress view that displays a spinner while the serer data is being downloaded.
     The view uses an activity indicator (a spinner) and a simple text to convey the information.
     Source: YouTube
     Tutorial: Swift - How to Create Loading Bar (Spinners)
     Author: Melih Şimşek
     URL: https://www.youtube.com/watch?v=iPTuhyU5HkI
     */
    func setProgressView()
    {
        self.progressView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        self.progressView.backgroundColor = UIColor.darkGray
        self.progressView.layer.cornerRadius = 10
        let wait = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        wait.color = UIColor.white
        //UIColor(red: 254/255, green: 218/255, blue: 2/255, alpha: 1)
        wait.hidesWhenStopped = false
        wait.startAnimating()
        
        let message = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        message.text = "Loading webpage..."
        message.textColor = UIColor.white
        
        self.progressView.addSubview(wait)
        self.progressView.addSubview(message)
        self.progressView.center = self.view.center
        self.progressView.tag = 1000
        
    }
    
    /*
     This method is invoked to remove the progress spinner from the view.
     Source: YouTube
     Tutorial: Swift - How to Create Loading Bar (Spinners)
     Author: Melih Şimşek
     URL: https://www.youtube.com/watch?v=iPTuhyU5HkI
     */
    func stopProgressView()
    {
        // self.progressView.removeFromSuperview()
        let subviews = self.view.subviews
        for subview in subviews
        {
            if subview.tag == 1000
            {
                subview.removeFromSuperview()
            }
        }
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    
}

