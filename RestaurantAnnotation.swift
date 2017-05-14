//
//  RestaurantAnnotation.swift
//  Iconified
//
//  Created by Shishira Skanda on 25/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//
/*
 Class representing the contents of annotation view
 It consists of location, name, image and isOpen status
 */

import UIKit
import MapKit

class RestaurantAnnotation: NSObject, MKAnnotation {
    
    //variables for the callout view
    var coordinate: CLLocationCoordinate2D
    var name: String!
    var isOpen: String!
    var image: UIImage!
    var place: Place!
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
