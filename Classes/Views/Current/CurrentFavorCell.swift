//
//  CurrentFavorCell.swift
//  Whistle
//
//  Created by Lu Cao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class CurrentFavorCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(favor : PFObject) {
        self.detailLabel.text = favor[Constants.Favor.Content] as? String
        switch favor[Constants.Favor.Status] as! Int {
        case 0:
            self.statusButton.setTitle("11", forState: .Normal)
        case 1:
            self.statusButton.setImage(nil, forState: .Normal)
            self.statusButton.setTitle("33", forState: .Normal)
        case 2:
            self.statusButton.setTitle("11", forState: .Normal)
        default:
            break
        }
        

    }
    
   

}
