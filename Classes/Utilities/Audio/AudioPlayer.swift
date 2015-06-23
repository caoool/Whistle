//
//  AudioPlayer.swift
//  Arrived
//
//  Created by Yetian Mao on 5/10/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import AVFoundation
import UIKit

class AudioPlayer : NSObject, AVAudioPlayerDelegate{
    
    var audioPlayer: AVAudioPlayer?
    var audioContext: AudioContext = AudioContext()
    
    override init(){
        super.init()
        audioContext.active()
    }
    
    func playAudio(path : NSURL){
        
        //println("file URL \(path)")
        //if it's ready playing an audio
        if (audioPlayer != nil) {
            if (audioPlayer!.playing){
                audioPlayer?.stop()
            }
            audioPlayer = nil
        }
        
        let closeToFace : Bool = UIDevice.currentDevice().proximityState
        
        if closeToFace {
            audioContext.enableProximityMonitor()
            audioContext.switchPlayEarphone()
        } else {
            audioContext.enableProximityMonitor()
            audioContext.switchPlaySpeaker()
        }
        
        /* Let's try to retrieve the data for the recorded file */
        var playbackError:NSError?
        var readingError:NSError?
        
        let fileData = NSData(contentsOfURL: path,
            options: .MappedRead,
            error: &readingError)
        
        /* Form an audio player and make it play the recorded data */
        audioPlayer = AVAudioPlayer(data: fileData, error: &playbackError)
        
        /* Could we instantiate the audio player? */
        if let player = audioPlayer{
            player.delegate = self
            
            /* Prepare to play and start playing */
            if player.prepareToPlay() && player.play(){
                println("Started playing the recorded audio")
            } else {
                println("Could not play the audio")
            }
            
        } else {
            println("Failed to create an audio player")
        }
    }
    
    func stopAudio(){
        if (audioPlayer != nil){
            if (audioPlayer!.playing){
                println("Recording playing stopped.")
                self.audioPlayer?.stop()
            }
        }
    }
    
}
