//
//  RecentCell.swift
//  Whistle
//
//  Created by Yetian Mao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class RecentCell : UITableViewCell {
    
    let imageName = "imageName"
    let userName = "userName"
    let message = "messageText"
    let dateText = "dateText"
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelLastMessage: UILabel!
    @IBOutlet weak var labelElapsed: UILabel!
    @IBOutlet weak var labelCounter: UILabel!
    
    func bindData(recent : NSDictionary)
    {
        imageUser.image = UIImage(named: recent[imageName] as! String)
        labelUserName.text = recent[userName] as? String
        labelLastMessage.text = recent[message] as? String
        labelElapsed.text = recent[dateText] as? String
        labelCounter.text = "2 new"
        
    }
    
}
