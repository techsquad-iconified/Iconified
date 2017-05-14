//
//  Hospital.swift
//  Iconified
//
//  Created by Shishira Skanda on 20/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

/*
 Entity class Hospital to hold the details of the emergency entities.
 */

import UIKit

class Hospital: NSObject {
    
    //Attributed of a Hospital or GP to be saved
    var name : String?
    var placeId: String?
    var address: String?
    var type: String?
    var phoneNumber: String?
    var email: String?
    var languageSpoken: String?
    var lat: Double?
    var isOpen: String?
    var lng: Double?
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
        self.name = nil
        self.placeId = nil
        self.address = nil
        self.type = nil
        self.isOpen = nil
        self.phoneNumber = nil
        self.email = nil
        self.languageSpoken = nil
        self.rating = nil
        self.priceLevel = nil
        self.website = nil
        self.url = nil
    }
    
    //Parameterized constructor
    init(name: String, address: String, type: String, lat: Double, lng: Double)
    {
        self.name = name
        self.address = address
        self.type = type
        self.lat = lat
        self.lng = lng
    }
    //Parameterized constructor using just latitue, longitude, id, name, rating and isOpen
    init(lat:Double, lng: Double, placeId: String, placeName: String, isOpen: String )
    {
        self.lat = lat
        self.lng = lng
        self.placeId = placeId
        self.name = placeName
        self.isOpen = isOpen
        
    }

    
    

}
