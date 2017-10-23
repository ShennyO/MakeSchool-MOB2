//
//  tripsTableViewCell.swift
//  Trip-Planner
//
//  Created by Sunny Ouyang on 10/14/17.
//  Copyright © 2017 Sunny Ouyang. All rights reserved.
//

import UIKit

class tripsTableViewCell: UITableViewCell {
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
