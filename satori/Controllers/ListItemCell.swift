//
//  ListViewCell.swift
//  affirm
//
//  Created by Jake on 5/21/19.
//  Copyright © 2019 Jake C Gardner. All rights reserved.
//

import UIKit

class ListItemCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
