//
//  User.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class User {
    
    static func updateProfilePhoto(portrait : UIImage, thumbnail : UIImage){
        
        var filePortrait : PFFile = PFFile(name: "portrait.jpg", data: UIImageJPEGRepresentation(portrait, 0.6))
        filePortrait.saveInBackground()
        
    }
    
    static func updateNickname(nickname : String){
        
    }
    
    static func updateProfileInfo(sex : Int?, birth : String?, status : String?){
        
    }
    
    static func getUser(userId : String) {
        let query = PFUser.query()
        query?.whereKey(Constants.User.ObjectId, equalTo: userId)
        query?.findObjectsInBackground()
    }
    
    
}