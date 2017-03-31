//
//  FoodPhotosViewController.swift
//  Iconified
//
//  Created by Shishira Skanda on 31/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

protocol photoViewDelegate {
    func photoSegue(selectedImage: UIImage, photoArray: [UIImage])
}


import UIKit

let reuserIdentifier = "PhotoCell"

class FoodPhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var photoCollectionView: UICollectionView!
    
    var selectedPlace: Place?
    var photoReferenceArray = [String]()
    var photoArray = [UIImage]()
    var seletedImage: UIImage?
    var delegate: photoViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoReferenceArray = (self.selectedPlace?.photoReference)!
        print("photo reference array size is \(self.photoReferenceArray.count)")
         DispatchQueue.main.async(){
        self.getphotos()
        }
        DispatchQueue.main.async(){
            print("photo array size is \(self.photoArray.count)")
        }
        
        // Do any additional setup after loading the view.
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        self.photoCollectionView.reloadData()
        }
        
    }
    
    //UICollectionViewDataSource Methods
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.photoArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: FoodPhotoCollectionViewCell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifier, for: indexPath) as! FoodPhotoCollectionViewCell
       // cell.backgroundColor = UIColor.red
        print("Shishira")
        var placeImage: UIImage = self.photoArray[indexPath.row] as! UIImage
        cell.photoImageView.image = placeImage
        
        return cell
        
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        self.seletedImage = self.photoArray[indexPath.row]
        self.delegate?.photoSegue(selectedImage: self.seletedImage!,photoArray: self.photoArray)
        print("Image selected is at index \(indexPath.row)")
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    

}
