//
//  EmergencyAnnotation.swift
//  Iconified
//
//  Created by Shishira Skanda on 20/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

//EmergencyAnnotation class consisting of the details to be displayed in the annotation call out view
import UIKit
import MapKit

class EmergencyAnnotation: NSObject, MKAnnotation {
        
        //variables for the callout view
        var coordinate: CLLocationCoordinate2D
        var name: String!
        var type: String!
        var image: UIImage!
        var hospital: Hospital!
    
    
        init(coordinate: CLLocationCoordinate2D) {
            self.coordinate = coordinate
        }
}



