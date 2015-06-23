//
//  AssistCell.swift
//  Arrived
//
//  Created by Lu Cao on 5/29/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AssistCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var portrait: UIImageView!
    @IBOutlet weak var status: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var indicatorDefault : UIImage = UIImage(named: "default_indicator")!
    private var indicatorProgressing : UIImage = UIImage(named: "processing_indicator")!
    private var indicatorFinished : UIImage = UIImage(named: "finished_indicator")!
    private var indicatorInterested : UIImage = UIImage(named: "interested_indicator")!
    
    // gestures
    var originalCenter = CGPoint()
    var interestedOnDragRelease = false
    
    var crossLabel: UILabel!    // for interest swipe
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor(red:0.95, green:0.69, blue:0.25, alpha:0)
        
        // add a pan recognizer
        var recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        
        // tick and cross labels for context cues
        crossLabel = createCueLabel()
        crossLabel.text = "Interest"
        crossLabel.font = UIFont(name: Constants.DefaultFont, size: 17)
        crossLabel.textAlignment = .Left
        addSubview(crossLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 80.0
        crossLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0,
            width: kUICuesWidth, height: bounds.size.height)
        
        //view.roundCorners(.TopLeft | .BottomLeft, radius: view.layer.bounds.height/2)
        view.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.layer.borderWidth = 0
        view.layer.cornerRadius = 12
        
        portrait.layer.borderColor = UIColor.whiteColor().CGColor
        portrait.layer.borderWidth = 2
        //portrait.layer.cornerRadius = portrait.layer.bounds.height/2
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
            interestedOnDragRelease = frame.origin.x < -frame.size.width / 3.5
            
            // fade the contextual clues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 3.5)
            crossLabel.alpha = cueAlpha
            // indicate when the user has pulled the item far enough to invoke the given action
            crossLabel.textColor = interestedOnDragRelease ? UIColor(red:0.95, green:0.69, blue:0.25, alpha:1) : UIColor.lightGrayColor()
        }
        // 3
        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            // if the item is not being deleted, snap back to the original location
            UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            
            if interestedOnDragRelease {
                // change status to interested or not interested
                if status.image == indicatorDefault {
                    status.image = indicatorInterested
                }
                else if status.image == indicatorInterested {
                    status.image = indicatorDefault
                }
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
    
    func bindData(favor : PFObject) {
        var user : PFUser = favor[Constants.Favor.User] as! PFUser
        var file = user[Constants.User.Portrait] as? PFFile
        file?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                 self.portrait.image = UIImage(data: data!)!
            }
        })
        titleLabel.text = favor[Constants.Favor.Content] as? String
        
        let likes = user[Constants.User.Likes] as! Int
        let dislikes = user[Constants.User.Dislikes] as! Int

        reviewLabel.text = "❤️ \(likes) 💔 \(dislikes)"
        
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
            
            let latitude = manager.location.coordinate.latitude
            let longitude = manager.location.coordinate.longitude
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            let currentLocation = PFGeoPoint(location: location)
            let distance = currentLocation.distanceInMilesTo(favor[Constants.Favor.Location] as? PFGeoPoint)
            self.distanceLabel.text = "\(Int(distance)) miles"
            
            switch favor[Constants.Favor.Status] as! Int {
                case 0:
                    self.status.image = self.indicatorDefault
                case 1:
                    self.status.image = self.indicatorProgressing
                case 2:
                    self.status.image = self.indicatorFinished
                default:
                    break
            }
        }

    }
}
