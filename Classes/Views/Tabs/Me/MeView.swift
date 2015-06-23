//
//  MeView.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class MeView : UITableViewController {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var status: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Me"
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        var query = PFUser.query()
        query!.fromLocalDatastore()
        query?.whereKey("objectId", equalTo:Constants.currentUser!)
        query!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            // Retrieve the Text column value of each PFObject
            if error == nil {
                let object: AnyObject? = objects?.first
                self.nickname.text = (object as! PFObject)["name"] as? String
            }
        }

    }
    

    

    
    
    
    
    
    
    
   
    
}
