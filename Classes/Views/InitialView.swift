//
//  InitialView.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class InitialView: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        let currentUser = PFUser.currentUser()
        println(currentUser?.objectId)
        Constants.currentUser = currentUser?.objectId
        if currentUser?.objectId != nil{
            self.performSegueWithIdentifier("toMain", sender: self)
        } else {
            self.performSegueWithIdentifier("toLogin", sender: self)
        }
        
    }
}
