//
//  FavorListCell.swift
//  Whistle
//
//  Created by Lu Cao on 7/2/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//


//----------------------------------------------------------------------------------------------------------
import UIKit
//----------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------
class FavorListCell: UITableViewCell
//----------------------------------------------------------------------------------------------------------
{

    // MARK: - IBOutlets
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var portraitView                         : UIImageView!
    @IBOutlet weak var nameLabel                            : UILabel!
    @IBOutlet weak var contentContainerView                 : UIView!
    @IBOutlet weak var audioView                            : FSVoiceBubble!
    @IBOutlet weak var distanceIcon                         : UIImageView!
    @IBOutlet weak var priceIcon                            : UIImageView!
    @IBOutlet weak var distanceLabel                        : UILabel!
    @IBOutlet weak var priceLabel                           : UILabel!
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
        backgroundColor                                         = Constants.Color.Background
        
        portraitView.layer.borderWidth                      = 3
        portraitView.layer.borderColor                      = Constants.Color.Border.CGColor
        portraitView.layer.cornerRadius                     = portraitView.layer.frame.height/2
    
        nameLabel.textColor                                 = Constants.Color.TextLight
        nameLabel.shadowColor                               = Constants.Color.Shadow
        nameLabel.shadowOffset                              = CGSizeMake(0, -1)
        
        contentContainerView.backgroundColor                = Constants.Color.ContentBackground
        contentContainerView.alpha                          = 0.85
        
        audioView.durationInsideBubble                      = true
        audioView.bubbleImage                               = UIImage(named: "fs_cap_bg")
        audioView.waveColor                                 = Constants.Color.Background
        audioView.animatingWaveColor                        = UIColor.grayColor()
        
        distanceIcon.layer.borderColor                      = Constants.Color.Border.CGColor
        distanceIcon.layer.borderWidth                      = 2
        distanceIcon.layer.cornerRadius                     = 25/2
        distanceIcon.backgroundColor                        = Constants.Color.Border
        let origImage1                                      = distanceIcon.image
        let tintedImage1                                    = origImage1!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        distanceIcon.image                                  = tintedImage1
        distanceIcon.tintColor                              =  Constants.Color.Background
        
        priceIcon.layer.borderColor                         = Constants.Color.Border.CGColor
        priceIcon.layer.borderWidth                         = 2
        priceIcon.layer.cornerRadius                        = 25/2
        priceIcon.backgroundColor                           = Constants.Color.Border
        let origImage2                                      = priceIcon.image
        let tintedImage2                                    = origImage2!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        priceIcon.image                                     = tintedImage2
        priceIcon.tintColor                                 = Constants.Color.Background
        
        priceLabel.textColor                                = Constants.Color.TextLight
        distanceLabel.textColor                             = Constants.Color.TextLight
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configshapes()
    //----------------------------------------------------------------------------------------------------------
    {
        
    }

}
