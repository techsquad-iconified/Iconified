//
//  StopsAnnotation.swift
//  Iconified
//
//  Created by Shishira Skanda on 22/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//
/*
 StopsAnnotation is a  class to hold details of annotation callout
 */
import UIKit
import MapKit

class StopsAnnotation: NSObject, MKAnnotation {
    
    //variables for the callout view
    var coordinate: CLLocationCoordinate2D
    var name: String!
    var routeType: Int!
    var stop: PtvStops!
    var image: UIImage!
    
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
