//
//  AudioContext.swift
//  Arrived
//
//  Created by Yetian Mao on 5/10/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import AVFoundation
import UIKit

class AudioContext: NSObject {
    
    var inited : Bool = false
    
    func active(){
        if (!inited){
            var error: NSError?
            let session = AVAudioSession.sharedInstance()
            if session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DuckOthers, error: &error){
                session.setActive(true, error: nil)
                println("Successfully activated the audio session")
                inited = true
            } else {
                if let theError = error{
                    println("An error occurred in setting the audio " +
                        "session category. Error = \(theError)")
                }
            }
        }
    }
    
    func deactive(){
        if (inited){
            let session = AVAudioSession.sharedInstance()
            session.setActive(false, error: nil)
            inited = false
        }
    }
    
    func switchRecord(){
        let session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    }
    
    func switchPlaySpeaker(){
        let session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
    }
    
    func switchPlayEarphone(){
        let session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    }
    
    func enableProximityMonitor(){
        UIDevice.currentDevice().proximityMonitoringEnabled = true
    }
    
    func disableProximityMonitor(){
        UIDevice.currentDevice().proximityMonitoringEnabled = false
    }
}
