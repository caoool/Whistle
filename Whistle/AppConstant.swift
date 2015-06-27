//
//  AppConstant.swift
//  Whistle
//
//  Created by Yetian Mao on 6/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

struct Constants {
    
    static var currentUser : String? = nil
    static let DefaultFont : String = "Helvetica"
    
    // Favor database key
    struct Favor {
        static let Name : String = "Favor"
        static let ObjectId : String = "objectId"
        static let Content : String = "content"
        static let User : String = "user"
        static let Tag : String = "tags"
        static let Location : String = "location"
        static let Audio : String = "audio"
        static let Image : String = "image"
        static let DefaultMileRange : Double = 5
        static let DefaultPaginationLimit : Int = 20
        static let Status : String = "status" // 0 is regular, 1 is in progress, 2 is finished
        static let PlaceHolder : String = "Need a favor? Whistle for help!"
        static let Award : String = "award"
        static let Price : String = "price"
        static let Interested : String = "interested_users"
    }
    
    struct User {
        static let Name : String = "User"
        static let Email : String = "email"
        static let ObjectId : String = "objectId"
        static let Nickname : String = "name"
        static let Portrait : String = "portrait"
        static let Sex : String = "sex"
        static let Birth : String = "birth"
        static let Status : String = "status"
        static let Likes : String = "likes"
        static let Dislikes : String = "dislikes"
        static let Favors : String = "favors"
        static let Assists : String = "assists"
    }
    
    struct Color {
        static let Test : UIColor = UIColor.brownColor()
        static let TextLight : UIColor = UIColor.whiteColor()
        static let TextDark : UIColor = UIColor.darkTextColor()
        static let TextDark2 : UIColor = UIColor.darkGrayColor()
        static let AudioViewColor: UIColor = UIColor.blackColor()
        static let AudioViewProgressColor: UIColor = UIColor.grayColor()
    }
    
    struct Radius {
        static let CornerBig : CGFloat = 12
        static let BorderWidthMid : CGFloat = 3
    }
    
    struct Notification {
        static let SetProfileView : String = "loadSetProfileView"
    }
    
}
