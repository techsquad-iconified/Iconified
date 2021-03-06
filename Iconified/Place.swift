//
//  Place.swift
//  Iconified
//
//  Created by Shishira Skanda on 24/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

/*
 Entity class to represent the Place entity.
 Consists of all sttribute values of teh class that is stored.
 */

import UIKit

class Place: NSObject {
    
    //Attrinutes of the place entity
    var lat: Double?
    var lng: Double?
    var placeId: String?
    var placeName: String?
    var isOpen: String?
    var placeAddress: String?
    var phoneNumber: String?
    var rating: Float?
    var priceLevel: Int?
    var website: String?
    var url: String?
    var firstPhoto = UIImage()
    var photoReference = [String]()
    
    //default constructor
    override init(){
        self.lat = nil
        self.lng = nil
        self.placeId = nil
        self.placeName = nil
        self.isOpen = nil
        self.placeAddress = nil
        self.phoneNumber = nil
        self.rating = nil
        self.priceLevel = nil
        self.website = nil
        self.url = nil
        //self.photos = [UIImage]()
    }
    
    //Parameterized constructor using just latitue and longitude
    init(lat:Double, lng: Double)
    {
        self.lat = lat
        self.lng = lng
        
    }
    //Parameterized constructor using just latitue, longitude, id, name, address and isOpen
    init(lat:Double, lng: Double, placeId: String, placeName: String, placeAddress: String, isOpen: String )
    {
        self.lat = lat
        self.lng = lng
        self.placeId = placeId
        self.placeName = placeName
        self.placeAddress = placeAddress
        self.isOpen = isOpen
        
    }
    //Parameterized constructor using all attrinutes
    init(lat:Double, lng: Double, placeId: String, placeName: String, placeAddress: String, isOpen: String, phoneNumber: String, rating: Float, priceLevel: Int, website: String, url: String, firstPhoto: UIImage)
    {
        self.lat = lat
        self.lng = lng
        self.placeId = placeId
        self.placeName = placeName
        self.placeAddress = placeAddress
        self.isOpen = isOpen
        self.phoneNumber = phoneNumber
        self.rating = rating
        self.priceLevel = priceLevel
        self.website = website
        self.url = url
        self.firstPhoto = firstPhoto
    }

}
