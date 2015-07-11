//
//  ProfileView.swift
//  Whistle
//
//  Created by Lu Cao on 6/24/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//


//----------------------------------------------------------------------------------------------------------
import UIKit
import Parse
//----------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------
class ProfileView: UIViewController
//----------------------------------------------------------------------------------------------------------
{
    // MARK: - IBOutlets
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var bgView                                   : UIView!
    @IBOutlet weak var portraitView                             : UIImageView!
    @IBOutlet weak var nameLabel                                : UILabel!
    @IBOutlet weak var lineLabel                                : UILabel!
    @IBOutlet weak var whistleCountLabel                        : UILabel!
    @IBOutlet weak var assistCountLabel                         : UILabel!
    @IBOutlet weak var likesCountLabel                          : UILabel!
    @IBOutlet weak var whistleIcon                              : UIImageView!
    @IBOutlet weak var rewardIcon                               : UIImageView!
    @IBOutlet weak var likesIcon                                : UIImageView!
    //----------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Initializations
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    //----------------------------------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        configLooks()
        
        /* Parse
        var user = PFUser.currentUser()!
        var file = user[Constants.User.Portrait] as! PFFile
        file.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                self.portraitView.image = UIImage(data: data!)!
            }
        })
        self.nameLabel.text = user[Constants.User.Nickname] as? String
        */
    }

    //----------------------------------------------------------------------------------------------------------
    override func viewWillAppear(animated: Bool)
    //----------------------------------------------------------------------------------------------------------
    {
        super.viewWillAppear(true)
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLayoutSubviews()
    //----------------------------------------------------------------------------------------------------------
    {
    }
    
    
    // MARK: - IBActions
    //----------------------------------------------------------------------------------------------------------
    @IBAction func navBarItemRightTapped(sender: UIBarButtonItem)
    //----------------------------------------------------------------------------------------------------------
    {
        performSegueWithIdentifier("profileToSettings", sender: self)
    }
    
    
    // MARK: - Functions
    //----------------------------------------------------------------------------------------------------------
    func configLooks()
    //----------------------------------------------------------------------------------------------------------
    {
        navigationController?.navigationBar.translucent         = false
        navigationController?.navigationBar.shadowImage         = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        bgView.backgroundColor                                  = Constants.Color.NavigationBar
        
        portraitView.layer.borderColor                          = Constants.Color.TextLight.CGColor
        portraitView.layer.borderWidth                          = 2
        portraitView.layer.cornerRadius                         = 50
        
        var labelList = [nameLabel, lineLabel, whistleCountLabel, assistCountLabel, likesCountLabel]
        for element in labelList {
            element.textColor                                   = Constants.Color.CellText
            element.shadowColor                                 = Constants.Color.CellTextShadow
            element.shadowOffset                                = CGSizeMake(0, -1)
        }
        
        var iconList = [whistleIcon, rewardIcon, likesIcon]
        for element in iconList {
            element.layer.borderColor                           = Constants.Color.Border.CGColor
            element.layer.borderWidth                           = 1.5
            element.layer.cornerRadius                          = 12.5
            element.backgroundColor                             = Constants.Color.Border
            let origImage                                       = element.image
            let tintedImage                                     = origImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            element.image                                       = tintedImage
            element.tintColor                                   = Constants.Color.NavigationBar
        }
    }
    
    
}
