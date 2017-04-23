//
//  LanguageTableViewCell.swift
//  Iconified
//
//  Created by Shishira Skanda on 21/4/17.
//  Copyright © 2017 Shishira Skanda. All rights reserved.
//

/*
LanguageTableViewCell is a Table view cell class that is used to store the image of the flags to represent different languages
 */
import UIKit

class LanguageTableViewCell: UITableViewCell {
    
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
