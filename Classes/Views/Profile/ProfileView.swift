//
//  ProfileView.swift
//  Whistle
//
//  Created by Lu Cao on 6/24/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class ProfileView: UIViewController {
    
    private var o = false
    // MARK: - IBOutlets
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var portraitView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lineLabel: UILabel!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var favorsLabel: UILabel!
    
    private var halo: PulsingHaloLayer = PulsingHaloLayer()
    private var isAvailable: Bool = true {
        didSet {
            halo.backgroundColor = isAvailable ? Constants.Color.IsAvailableHaloColor.CGColor : Constants.Color.NotAvailableHaloColor.CGColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var user = PFUser.currentUser()!
        var file = user[Constants.User.Portrait] as! PFFile
        file.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                self.portraitView.image = UIImage(data: data!)!
            }
        })
        self.nameLabel.text = user[Constants.User.Nickname] as? String
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "logOut:")
        colorConfig()
        addGestures()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        shapeConfig()
    }
    
    func logOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func colorConfig() {
        infoView.backgroundColor = Constants.Color.Test
        nameLabel.textColor = Constants.Color.TextLight
        lineLabel.textColor = Constants.Color.TextLight
        likesLabel.textColor = Constants.Color.TextLight
        favorsLabel.textColor = Constants.Color.TextLight
    }
    
    func shapeConfig() {
        infoView.roundCorners(UIRectCorner.TopLeft | UIRectCorner.TopRight, radius: Constants.Radius.CornerBig)
        portraitView.image = portraitView.image?.rounded
        portraitView.layer.borderColor = UIColor.whiteColor().CGColor
        portraitView.layer.borderWidth = 1
        portraitView.layer.cornerRadius = portraitView.layer.frame.height/2
        portraitView.layer.masksToBounds = true
        
        halo.position = portraitView.center
        halo.radius = 300
        infoView.layer.addSublayer(halo)
    }
    
    func addGestures() {
        var tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        portraitView.addGestureRecognizer(tapGesture)
    }
    
    func handleTapGesture(sender: UITapGestureRecognizer){
        isAvailable = !isAvailable
    }
    
}
