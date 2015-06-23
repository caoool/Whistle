//
//  MyFavorsAssistantCell.swift
//  Whistle
//
//  Created by Lu Cao on 5/31/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class MyFavorsAssistantCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var portrait: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var dislikes: UILabel!
    @IBOutlet weak var jobsDone: UILabel!
    
    // gestures
    var originalCenter = CGPoint()
    var requireOnDragRelease = false
    
    var crossLabel: UILabel!    // for insterest swipe
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initCell()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 80.0
        crossLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0,
            width: kUICuesWidth, height: bounds.size.height)
    }
    
    override func drawRect(rect: CGRect) {

        bgView.alpha = 1
        bgView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:0.95)
        contentView.backgroundColor = UIColor.clearColor()
        
        bgView.layer.borderColor = UIColor.whiteColor().CGColor
        bgView.layer.borderWidth = 1
        bgView.layer.cornerRadius = 12
        
        portrait.layer.borderWidth = 1
        portrait.layer.borderColor = UIColor.whiteColor().CGColor
        portrait.layer.cornerRadius = 8
        portrait.alpha = 1
        
        price.layer.borderWidth = 1
        price.layer.borderColor = UIColor.whiteColor().CGColor
        price.layer.cornerRadius = price.layer.frame.height/2
        price.alpha = 0.35
    }
    
    func initCell() {
        
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        
        // add a pan recognizer
        var recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        
        // tick and cross labels for context cues
        crossLabel = createCueLabel()
        crossLabel.text = "Require"
        crossLabel.font = UIFont(name: Constants.DefaultFont, size: 17)
        crossLabel.textAlignment = .Left
        addSubview(crossLabel)
        
    }
    
    //MARK: - horizontal pan gesture methods
    func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            requireOnDragRelease = frame.origin.x < -frame.size.width / 3.5
            
            // fade the contextual clues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 3.5)
            crossLabel.alpha = cueAlpha
            // indicate when the user has pulled the item far enough to invoke the given action
            crossLabel.textColor = requireOnDragRelease ? UIColor(red:0.37, green:0.83, blue:0.69, alpha:1) : UIColor.lightGrayColor()
        }
        // 3
        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            // if the item is not being deleted, snap back to the original location
            UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            
            if requireOnDragRelease {
                println("123")
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    // utility method for creating the contextual cues
    func createCueLabel() -> UILabel {
        let label = UILabel(frame: CGRect.nullRect)
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(32.0)
        label.backgroundColor = UIColor.clearColor()
        return label
    }
    
    func bindData(user : PFUser) {
        var file = user[Constants.User.Portrait] as? PFFile
        file?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                self.portrait.image = UIImage(data: data!)!
            }
        })
        self.nickname.text = user[Constants.User.Nickname] as? String
        self.status.text = user[Constants.User.Status] as? String
        self.likes.text = "\(user[Constants.User.Likes] as! Int)"
        self.dislikes.text = "\(user[Constants.User.Dislikes] as! Int)"
        self.jobsDone.text = "\(user[Constants.User.Assists] as! Int)"
        
    }

}
