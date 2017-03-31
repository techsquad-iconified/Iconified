//
//  ALRadialMenuButtonAction.swift
//  Iconified
//
//  Created by Shishira Skanda on 29/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

public typealias ALRadialMenuButtonAction = () -> Void

//Class to generate UIButtons to Radial Menu
public class ALRadialMenuButton: UIButton {
    
    //public method to configure the buttons
    public var action: ALRadialMenuButtonAction? {
        didSet {
            configureAction()
        }
    }
    //Configure method to set action method the buttons
    private func configureAction() {
        addTarget(self, action: #selector(performAction), for: .touchUpInside)
    }
    
    //action method to the buttons
    internal func performAction() {
        if let a = action {
            a()
        }
    }
}
