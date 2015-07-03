//
//  ProfileFavorCell.swift
//  Whistle
//
//  Created by Lu Cao on 6/28/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class ProfileFavorCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var portrait1: UIImageView!
    @IBOutlet weak var portrait2: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var leftMoreCons: NSLayoutConstraint!
    @IBOutlet weak var leftLessCons: NSLayoutConstraint!
    @IBOutlet weak var rightMoreCons: NSLayoutConstraint!
    @IBOutlet weak var rightLessCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindData(favor: PFObject, previousFavor: PFObject?) {
        
        var user = PFUser.currentUser()!
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd"
        self.dateLabel.text = formatter.stringFromDate(favor.updatedAt!)
        if previousFavor != nil {
            if self.dateLabel.text == formatter.stringFromDate(previousFavor!.updatedAt!) {
                self.dateLabel.hidden = true
            }
        }
        
        if (favor[Constants.Favor.CreatedBy] as! PFUser) == user {
            self.portrait2.hidden = true
            self.leftLessCons.active = true
            self.leftMoreCons.active = false
            var file = user[Constants.User.Portrait] as! PFFile
            file.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil {
                    self.portrait1.image = UIImage(data: data!)!
                }
            })
        } else {
            self.portrait1.hidden = true
            self.leftLessCons.active = false
            self.leftMoreCons.active = true
            var file = user[Constants.User.Portrait] as! PFFile
            file.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil {
                    self.portrait2.image = UIImage(data: data!)!
                }
            })
        }
        self.detailLabel.text = favor[Constants.Favor.Content] as? String

    }
    
}
