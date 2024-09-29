//
//  ProfileFavorCell.swift
//  Whistle
//
//  Created by Lu Cao on 6/28/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

//----------------------------------------------------------------------------------------------------------
import UIKit
import Parse
//----------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------
class ProfileFavorCell: UITableViewCell
//----------------------------------------------------------------------------------------------------------
{
    // MARK: - IBOutlets
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var line                                 : UIView!
    @IBOutlet weak var dotBottom                            : UIView!
    @IBOutlet weak var portrait                             : UIImageView!
    @IBOutlet weak var dateLabel                            : UILabel!
    @IBOutlet weak var nameWhistledLabel                    : UILabel!
    @IBOutlet weak var nameAssistedLabel                    : UILabel!
    //----------------------------------------------------------------------------------------------------------
    // Constraints
    //----------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Initializations
    //----------------------------------------------------------------------------------------------------------
    override func awakeFromNib()
    //----------------------------------------------------------------------------------------------------------
    {
        super.awakeFromNib()
        configLooks()
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func prepareForReuse()
    //----------------------------------------------------------------------------------------------------------
    {
        dateLabel.text = ""
        nameWhistledLabel.text = ""
        nameAssistedLabel.text = ""
        dotBottom.hidden = true
        portrait.hidden = false
        line.hidden = false
    }
    
    
    // MARK: - Functions
    //----------------------------------------------------------------------------------------------------------
    func configLooks()
    //----------------------------------------------------------------------------------------------------------
    {
        backgroundColor                                     = Constants.Color.CellBackground
        
        line.backgroundColor                                = Constants.Color.Border
        dotBottom.backgroundColor                           = Constants.Color.Border
        dotBottom.layer.cornerRadius                        = 7.5
        
        portrait.layer.borderColor                          = Constants.Color.Border.CGColor
        portrait.layer.borderWidth                          = 2
        portrait.layer.cornerRadius                         = 30
        portrait.backgroundColor                            = Constants.Color.Border
        
        dateLabel.textColor                                 = Constants.Color.CellTextReverse
        dateLabel.backgroundColor                           = Constants.Color.CellText
        dateLabel.layer.cornerRadius                        = 7.5
        nameWhistledLabel.textColor                         = Constants.Color.CellText
        nameAssistedLabel.textColor                         = Constants.Color.CellText
    }
    
    //----------------------------------------------------------------------------------------------------------
    func bindData(favor: PFObject, previousFavor: PFObject?)
    //----------------------------------------------------------------------------------------------------------
    {
        var user = PFUser.currentUser()!
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd"
        self.dateLabel.text = "  \(formatter.stringFromDate(favor.updatedAt!))  "
        if previousFavor != nil {
            if self.dateLabel.text == "  \(formatter.stringFromDate(previousFavor!.updatedAt!))  " {
                self.dateLabel.text = ""
            }
        }
        if (favor[Constants.Favor.CreatedBy] as! PFUser) == user {
            var file = user[Constants.User.Portrait] as! PFFile
            file.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil {
                    self.portrait.image = UIImage(data: data!)!
                    self.nameAssistedLabel.text = favor[Constants.Favor.Content] as? String
//                    self.nameWhistledLabel.text = 
                }
            })
        } else {
            var file = user[Constants.User.Portrait] as! PFFile
            file.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil {
                    self.portrait.image = UIImage(data: data!)!
                    self.nameWhistledLabel.text = favor[Constants.Favor.Content] as? String
                }
            })
        }
    }
    
}
