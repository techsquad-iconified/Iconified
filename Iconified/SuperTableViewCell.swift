//
//  SuperTableViewCell.swift
//  Iconified
//
//  Created by 张翼扬 on 3/5/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

import UIKit

class SuperTableViewCell: UITableViewCell {
    
    //UI Controls
    @IBOutlet var flagImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //Method to set as selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
