//
//  PtvStops.swift
//  Iconified
//
//  Created by Shishira Skanda on 10/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class PtvStops: NSObject {
    
    var routeType: Int?
    var stopDistance: Double?
    var stopId: Int?
    var stopLatitude: Double?
    var stopLongitude: Double?
    var stopName: String?
    
    //default constructor
    override init(){
        
        self.routeType = nil
        self.stopDistance = nil
        self.stopId = nil
        self.stopLatitude = nil
        self.stopLongitude = nil
        self.stopName = nil
    }
    
    //Parameterized constructor using just latitue and longitude
    init(routeType: Int, stopDistance: Double, stopId: Int, stopLatitude: Double, stopLongitude: Double, stopName: String)
    {
        self.routeType = routeType
        self.stopDistance = stopDistance
        self.stopId = stopId
        self.stopLatitude = stopLatitude
        self.stopLongitude = stopLongitude
        self.stopName = stopName
        
    }
   
    

}
