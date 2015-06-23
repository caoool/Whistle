//
//  FavorCell.swift
//  Arrived
//
//  Created by Lu Cao on 5/31/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class FavorCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var status: UIImageView!
    @IBOutlet weak var takersButton: UIButton!
    
    private var indicatorDefault : UIImage = UIImage(named: "default_indicator_favor")!
    private var indicatorProgressing : UIImage = UIImage(named: "processing_indicator_favor")!
    private var indicatorFinished : UIImage = UIImage(named: "finished_indicator_favor")!
    private var progressingIcon : UIImage = UIImage(named: "processing_icon")!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColorFromHex(0xFFFFFF, alpha: 0)
        bgView.alpha = 0.65
        setUpCell()
    }
    
    func setUpCell() {
        
        selectionStyle = .None
        bgView.roundCorners(.TopLeft | .BottomLeft, radius: bgView.layer.bounds.height/2)
        bgView.layer.borderColor = UIColor.lightGrayColor().CGColor
        bgView.layer.borderWidth = 0
        bgView.layer.cornerRadius = 8
        
        takersButton.layer.borderWidth = 1.2
        takersButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        takersButton.layer.cornerRadius = takersButton.layer.frame.height/2
        takersButton.alpha = 0.65
        status.alpha = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func bindData(favor : PFObject) {
        
        self.titleLabel.text = favor[Constants.Favor.Content] as? String
            
        switch favor[Constants.Favor.Status] as! Int {
        case 0:
            self.status.image = self.indicatorDefault
        case 1:
            self.status.image = self.indicatorProgressing
            self.takersButton.setTitle("", forState: .Normal)
            self.takersButton.setImage(self.progressingIcon, forState: .Normal)
            self.takersButton.backgroundColor = UIColor.clearColor()
        case 2:
            self.status.image = self.indicatorFinished
        default:
            break
        }
        
    }
    
}
