//
//  CurrentAssistCell.swift
//  Whistle
//
//  Created by Lu Cao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class CurrentAssistCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //----------------------------------------------------------------------------------------------------------
    
    @IBOutlet weak var buttons                              : UIView!
    @IBOutlet weak var wrapper                              : UIView!
    @IBOutlet weak var contentLabel                         : UILabel!
    @IBOutlet weak var portraitView                         : UIImageView!
    @IBOutlet weak var nameLabel                            : UILabel!
    @IBOutlet weak var banner                               : UIView!
    @IBOutlet weak var audioView                            : FSVoiceBubble!
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
        
        portraitView.layer.borderWidth                      = 3
        portraitView.layer.borderColor                      = Constants.Color.Border.CGColor
        portraitView.layer.cornerRadius                     = portraitView.layer.frame.height/2
        
        nameLabel.textColor                                 = Constants.Color.TextLight
        nameLabel.shadowColor                               = Constants.Color.Shadow
        nameLabel.shadowOffset                              = CGSizeMake(0, -1)
        
        banner.backgroundColor                              = UIColorFromHex(0x3892DE, alpha: 1)
        
        wrapper.backgroundColor                             = Constants.Color.ContentBackground
        
        buttons.backgroundColor                             = Constants.Color.ContentBackground
        
        audioView.durationInsideBubble                      = true
        audioView.bubbleImage                               = UIImage(named: "fs_cap_bg")
        audioView.waveColor                                 = Constants.Color.Background
        audioView.animatingWaveColor                        = UIColor.grayColor()
    }
    
    func addText (content: String)
    {
        self.audioView.hidden = true
        self.contentLabel.text = content
        self.contentLabel.textColor = Constants.Color.TextLight
    }

}
