//
//  CuisineTableViewCell.swift
//  Iconified
//
//  Created by Shishira Skanda on 17/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//
/*
 UITableViewCell controller to display flags of different country cuisines
 */
import UIKit

class CuisineTableViewCell: UITableViewCell {

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
