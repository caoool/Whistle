//
//  AudioManager.swift
//  Arrived
//
//  Created by Yetian Mao on 5/10/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import Foundation
import Parse

class AudioManager: NSObject {
    
    // Define Audio Directory
    func audioDir() -> NSURL{
        let fileManager = NSFileManager()
        let documentsFolderUrl = fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask,
            appropriateForURL: nil,
            create: false,
            error: nil)
        let userFolderUrl = documentsFolderUrl!.URLByAppendingPathComponent("userId")
        if !fileManager.fileExistsAtPath(userFolderUrl.path!){
            fileManager.createDirectoryAtURL(userFolderUrl, withIntermediateDirectories: true, attributes: nil, error: nil)
            println("audio folder created")
        }
        //println("audio folder is \(userFolderUrl)")
        return userFolderUrl
    }
    
    func audioURLWithName(name : NSString) -> NSURL{
        let audioDir = self.audioDir()
        return audioDir.URLByAppendingPathComponent("\(name).m4a")
    }
    
    func audioWithName(name : NSString) -> NSData?{
        var data : NSData?
        let path = self.audioURLWithName(name)
        if self.exists(path.path!) {
            let error : NSErrorPointer = nil
            data = NSData(contentsOfURL: path, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: error)
            if error != nil {
                return nil
            }
        }
        return data
    }
    
    func exists(path: NSString) -> Bool{
        var isDirectory : ObjCBool = true
        let returnValue : Bool = NSFileManager().fileExistsAtPath(path as String, isDirectory: &isDirectory)
        if (!returnValue || isDirectory){
            return false
        }
        return true
    }
    
    func removeAudioWithName(name: NSString) -> Bool{
        let path = self.audioURLWithName(name)
        if self.exists(path.path!) {
            let error : NSErrorPointer = nil
            NSFileManager().removeItemAtURL(path, error: error)
            if (error == nil){
                return true
            }
        }
        return false
    }
    
    func saveAudio(data: NSData, name: NSString) -> Bool{
        if(name.length > 0){
            var error : NSError?
            let path = self.audioURLWithName(name)
            
            data.writeToFile(path.path!, options: NSDataWritingOptions.DataWritingFileProtectionComplete, error: &error)
            if (error == nil){
                return true
            }
        }
        return false
    }
    
}

