//
//  MarketAnnotation.swift
//  Iconified
//
//  Created by 张翼扬 on 3/5/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//
import UIKit
import MapKit

class MarketAnnotation: NSObject, MKAnnotation {
    
    
    //variables for the callout view
    var coordinate: CLLocationCoordinate2D
    var name: String!
    var isOpen: String!
    var image: UIImage!
    var Market: Market!
    
    override init() {
         self.coordinate = CLLocationCoordinate2D()
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

