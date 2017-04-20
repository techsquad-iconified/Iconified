//
//  CustomCalloutView.swift
//  CustomCalloutView
//
//  Created by Shishira Skanda on 20/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved
//
/*
 Class representing the calloutview
 the view is called when an annotation is selected
 */
import UIKit

class CustomCalloutView: UIView {

    //UI components of the view
    @IBOutlet var restaurantImage: UIImageView!
    @IBOutlet var restaurantName: UILabel!
    @IBOutlet var restaurantIsOpen: UILabel!
    
    @IBOutlet var detailsIcon: UIImageView!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}
