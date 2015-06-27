//
//  ProfileFavorCell.swift
//  Whistle
//
//  Created by Lu Cao on 6/28/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class ProfileFavorCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var portrait1: UIImageView!
    @IBOutlet weak var portrait2: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var leftMoreCons: NSLayoutConstraint!
    @IBOutlet weak var rightMoreCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
