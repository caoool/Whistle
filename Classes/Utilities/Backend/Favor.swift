//
//  Help.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/11/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse

struct Favor {
    var location : PFGeoPoint?
    var content : String?
    var image0 : PFFile?
    var image1 : PFFile?
    var image2 : PFFile?
    var audio : PFFile?
    var tags : [String]?
    var id : String?
    var user : PFUser?
}

class FavorBackend {
    
    // Post Favors
    static func postFavor(content : String?, images : [NSData]?, audio : NSData?, location : PFGeoPoint?, tags : [String]?) {
        var favor : PFObject = PFObject(className: Constants.Favor.Name)
        var fileImage : PFFile
        var fileAudio : PFFile
        var index : Int = 0
        
        if content != nil {
            favor[Constants.Favor.Content] = content
        }
        
        if images != nil {
            for image in images! {
                fileImage = PFFile(name: "picture.jpg", data: image)
                fileImage.saveInBackgroundWithBlock { (success : Bool, error : NSError?) -> Void in
                    if success {
                        println("Image success")
                    } else {
                        println("error" )
                    }
                }
                favor[Constants.Favor.Image + "\(index)"] = fileImage
                index = index + 1
            }
        }
        
        if audio != nil{
            fileAudio = PFFile(name: "Recording.m4a", data: audio!)
            fileAudio.saveInBackgroundWithBlock { (success : Bool, error : NSError?) -> Void in
                if success {
                    println("Audio success")
                } else {
                    println("error" )
                }
            }
            favor[Constants.Favor.Audio] = fileAudio
        }
        
        if location != nil {
            favor[Constants.Favor.Location] = location
        }
        
        favor[Constants.Favor.User] = PFUser.currentUser()
        favor[Constants.Favor.Tag] = tags
        
        favor.saveInBackgroundWithBlock {
            (success : Bool, error : NSError?) -> Void in
            if (success) {
                println("Favor posted successfully")
                
            } else {
                println(error!.description)
            }
            
        }
    }
    
    // Query Favors
    static func queryFavorByTag(tags : [String]?, location : PFGeoPoint?, var mileRange : Double?) -> [Favor]{
        let favorQuery : PFQuery = PFQuery(className: Constants.Favor.Name)
        var favors : [Favor] = [Favor]()
        if tags != nil {
            favorQuery.whereKey(Constants.Favor.Tag, containedIn: tags!)
        }
        if mileRange == nil {
            mileRange = Constants.Favor.DefaultMileRange
        }
        if location != nil {
            favorQuery.whereKey(Constants.Favor.Location, nearGeoPoint: location!, withinMiles: mileRange!)
        }
        favorQuery.limit = Constants.Favor.DefaultPaginationLimit
        favorQuery.includeKey(Constants.Favor.Tag)
        
//        var error : NSErrorPointer = NSErrorPointer()
//        var objects = favorQuery.findObjects(error)
//        
//        if objects != nil {
//            for object in objects! {
//                var favor : Favor = Favor()
//                favor.id = object[Constants.Favor.ObjectId] as? String
//                favor.content = object[Constants.Favor.Content] as? String
//                favor.tags = object[Constants.Favor.Tag] as? [String]
//                favor.image0 = object[Constants.Favor.Image + "0"] as? PFFile
//                favor.image1 = object[Constants.Favor.Image + "1"] as? PFFile
//                favor.audio = object[Constants.Favor.Audio] as? PFFile
//                favor.location = object[Constants.Favor.Location] as? PFGeoPoint
//                favor.user = object[Constants.Favor.User] as? PFUser
//                favors.append(favor)
//            }
//        }
        
        favorQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            for object in objects! {
                var favor : Favor = Favor()
                favor.id = object[Constants.Favor.ObjectId] as? String
                favor.content = object[Constants.Favor.Content] as? String
                favor.tags = object[Constants.Favor.Tag] as? [String]
                favor.image0 = object[Constants.Favor.Image + "0"] as? PFFile
                favor.image1 = object[Constants.Favor.Image + "1"] as? PFFile
                favor.audio = object[Constants.Favor.Audio] as? PFFile
                favor.location = object[Constants.Favor.Location] as? PFGeoPoint
                favor.user = object[Constants.Favor.User] as? PFUser
                favors.append(favor)
            }
        }
        return favors
    }
    
    
    
}
