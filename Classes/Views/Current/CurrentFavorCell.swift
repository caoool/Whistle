//
//  CurrentFavorCell.swift
//  Whistle
//
//  Created by Lu Cao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//


//----------------------------------------------------------------------------------------------------------
import UIKit
import Parse
//----------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------
class CurrentFavorCell: UITableViewCell
//----------------------------------------------------------------------------------------------------------
{

    // MARK: - IBOutlets
    //----------------------------------------------------------------------------------------------------------
    // Background color views
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var bannerView                           : UIView!
    @IBOutlet weak var wrapperView                          : UIView!
    @IBOutlet weak var buttonsView                          : UIView!
    //----------------------------------------------------------------------------------------------------------
    // Banner
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var statusButton                         : UIButton!
    @IBOutlet weak var statusLabel                          : UILabel!
    @IBOutlet weak var timeLabel                            : UILabel!
    //----------------------------------------------------------------------------------------------------------
    // Content
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var voiceView                            : FSVoiceBubble!
    @IBOutlet weak var contentLabel                         : UILabel!
    //----------------------------------------------------------------------------------------------------------
    // Buttons
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var leftButton                           : UIButton!
    @IBOutlet weak var midButton                            : UIButton!
    @IBOutlet weak var rightButton                          : UIButton!
    //----------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Initialization
    //----------------------------------------------------------------------------------------------------------
    override func awakeFromNib()
    //----------------------------------------------------------------------------------------------------------
    {
        super.awakeFromNib()
        configLooks()
    }
    
    // MARK: - Functions
    //----------------------------------------------------------------------------------------------------------
    func configLooks()
    //----------------------------------------------------------------------------------------------------------
    {
        backgroundColor                                     = Constants.Color.Background

        bannerView.backgroundColor                          = Constants.Color.Border
        wrapperView.backgroundColor                         = Constants.Color.ContentBackground
        buttonsView.backgroundColor                         = Constants.Color.Border
        
        statusLabel.textColor                               = Constants.Color.PlaceHolder
        timeLabel.textColor                                 = UIColor.lightGrayColor()
        contentLabel.textColor                              = Constants.Color.CellText
        
        statusButton.layer.borderWidth                      = 3
        statusButton.layer.borderColor                      = Constants.Color.Border.CGColor
        statusButton.layer.cornerRadius                     = statusButton.layer.frame.height/2
        statusButton.layer.backgroundColor                  = UIColorFromHex(0x9198A0, alpha: 1).CGColor
        
        voiceView.durationInsideBubble                      = true
        voiceView.bubbleImage                               = UIImage(named: "fs_cap_bg")
        voiceView.waveColor                                 = Constants.Color.Background
        voiceView.animatingWaveColor                        = UIColor.grayColor()
    }
    
    func addText (content: String)
    {
        self.voiceView.hidden = true
        self.contentLabel.text = content
    }
    
    func bindData(favor : PFObject) {
        self.contentLabel.text = favor[Constants.Favor.Content] as? String
        self.contentLabel.textColor = Constants.Color.TextLight
        var user : PFUser = favor[Constants.Favor.CreatedBy] as! PFUser
    }
    
   

}
