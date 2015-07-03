//
//  AppConstant.swift
//  Whistle
//
//  Created by Yetian Mao on 6/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//
//----------------------------------------------------------------------------------------------------------
import Foundation
//----------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------
struct Constants {
//----------------------------------------------------------------------------------------------------------
    
    //------------------------------------------------------------------------------------------------------
    static var currentUser                      : String? = nil
    static let DefaultFont                      : String  = "Helvetica"
    //------------------------------------------------------------------------------------------------------
    
    //------------------------------------------------------------------------------------------------------
    struct Favor {
        static let DefaultMileRange             : Double = 5
        static let DefaultPaginationLimit       : Int    = 20
        static let Name                         : String = "Favor"
        static let ObjectId                     : String = "objectId"
        static let Content                      : String = "content"
        static let Tag                          : String = "tags"
        static let Location                     : String = "location"
        static let Audio                        : String = "audio"
        static let Image                        : String = "image"
        static let Status                       : String = "status" // 0 is regular, 1 is in progress, 2 is finished
        static let PlaceHolder                  : String = "Need a favor? Whistle for help!"
        static let Reward                       : String = "reward"
        static let Price                        : String = "price"
        static let Takers                       : String = "interested_users"
        static let CreatedBy                    : String = "user"
        static let AssistedBy                   : String = "assistedBy"
        static let UpdatedAt                    : String = "updatedAt"
        static let CreatedAt                    : String = "createdAt"
    }
    //------------------------------------------------------------------------------------------------------
    
    //------------------------------------------------------------------------------------------------------
    struct User {
        static let Name                         : String = "User"
        static let Email                        : String = "email"
        static let ObjectId                     : String = "objectId"
        static let Nickname                     : String = "name"
        static let Portrait                     : String = "portrait"
        static let Sex                          : String = "sex"
        static let Birth                        : String = "birth"
        static let Status                       : String = "status"
        static let Likes                        : String = "likes"
        static let Dislikes                     : String = "dislikes"
        static let Favors                       : String = "favors"
        static let Assists                      : String = "assists"
    }
    //------------------------------------------------------------------------------------------------------
    
    //------------------------------------------------------------------------------------------------------
    struct Image {
        static let Name                         : String = "Image"
        static let File                         : String = "file"
    }
    //------------------------------------------------------------------------------------------------------
    
    //------------------------------------------------------------------------------------------------------
    struct Color {
        static let Test                         : UIColor = UIColor.brownColor()
        static let TextLight                    : UIColor = UIColor.whiteColor()
        static let TextDark                     : UIColor = UIColor.darkTextColor()
        static let TextDark2                    : UIColor = UIColor.darkGrayColor()
        static let AudioViewColor               : UIColor = UIColor.blackColor()
        static let AudioViewProgressColor       : UIColor = UIColor.grayColor()
        static let IsAvailableHaloColor         : UIColor = UIColor.blueColor()
        static let NotAvailableHaloColor        : UIColor = UIColor.grayColor()
        static let NavigationBarColor           : UIColor = UIColorFromHex(0x48D3B2, alpha: 1)
        static let NavigationBarTextColor       : UIColor = UIColorFromHex(0xFFFFFF, alpha: 1)
        static let GlobalTintColor              : UIColor = UIColorFromHex(0x48D3B2, alpha: 1)
        static let TableBackgroundColor         : UIColor = UIColorFromHex(0xFFFFFF, alpha: 1)
        static let CellBackgroundColor          : UIColor = UIColorFromHex(0xFFFFFF, alpha: 1)
    }
    //------------------------------------------------------------------------------------------------------
    
    //------------------------------------------------------------------------------------------------------
    struct Radius {
        static let CornerBig                    : CGFloat = 12
        static let BorderWidthMid               : CGFloat = 3
    }
    //------------------------------------------------------------------------------------------------------
    
    //------------------------------------------------------------------------------------------------------
    struct Notification {
        static let SetProfileView               : String = "loadSetProfileView"
    }
    //------------------------------------------------------------------------------------------------------
}

