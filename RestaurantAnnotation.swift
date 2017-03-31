//
//  RestaurantAnnotation.swift
//  Iconified
//
//  Created by Shishira Skanda on 25/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit
import MapKit

class RestaurantAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var name: String!
    var isOpen: String!
    var image: UIImage!
    var place: Place!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
