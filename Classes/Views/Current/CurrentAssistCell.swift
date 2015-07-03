//
//  CurrentAssistCell.swift
//  Whistle
//
//  Created by Lu Cao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class CurrentAssistCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    @IBOutlet weak var ownerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
