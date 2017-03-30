//
//  ALRadialMenuButtonAction.swift
//  Iconified
//
//  Created by Shishira Skanda on 29/3/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

public typealias ALRadialMenuButtonAction = () -> Void

public class ALRadialMenuButton: UIButton {
    public var action: ALRadialMenuButtonAction? {
        didSet {
            configureAction()
        }
    }
    
    private func configureAction() {
        addTarget(self, action: #selector(performAction), for: .touchUpInside)
    }
    
    internal func performAction() {
        if let a = action {
            a()
        }
    }
}
