//
//  CurrentFavorAssistantCell.swift
//  Whistle
//
//  Created by Lu Cao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class CurrentFavorAssistantCell: UITableViewCell {

    @IBOutlet weak var portraitImageView: UIImageView!
    
    var favor : PFObject!
    var user : PFUser!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func hire(sender: UIButton) {
        favor[Constants.Favor.AssistedBy] = self.user
        favor.saveInBackgroundWithBlock({ (success, error) -> Void in
            if error == nil {
                println("hire succeeded")
            } else {
                println("failed")
            }
        })
    }
    
    func bindData(user : PFUser){
        self.user = user
        var file = user[Constants.User.Portrait] as! PFFile
        file.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                self.portraitImageView.image = UIImage(data: data!)!
            }
        })
    }

}
