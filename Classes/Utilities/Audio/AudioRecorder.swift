//
//  AudioRecorder.swift
//  Arrived
//
//  Created by Yetian Mao on 5/9/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import AVFoundation


class AudioRecorder: NSObject, AVAudioRecorderDelegate{
    
    var audioRecorder: AVAudioRecorder?
    var audioContext: AudioContext = AudioContext()
    var maxDuration: NSTimeInterval = 60
    
    override init() {
        super.init()
        audioContext.active()
    }
    
    func initRecorder(name : NSString){
        var error: NSError?
        let audioRecordingURL = AudioManager().audioDir().URLByAppendingPathComponent("\(name).m4a")
        audioRecorder = AVAudioRecorder(URL: audioRecordingURL,
            settings: audioRecordingSettings(),
            error: &error)
        audioRecorder?.meteringEnabled = true
    }
    
    func audioRecordingPath() -> NSURL{
        let fileManager = NSFileManager()
        let documentsFolderUrl = fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask,
        appropriateForURL: nil,
        create: false,
        error: nil)
        return documentsFolderUrl!.URLByAppendingPathComponent("Recording.m4a")
    }
    
    func audioRecordingSettings() -> [NSObject : AnyObject]{
            
        return [
            // 音频格式
            AVFormatIDKey : kAudioFormatMPEG4AAC as NSNumber,
            // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量
            AVSampleRateKey : 16000.0 as NSNumber,
            // 音频通道数 1 或 2
            AVNumberOfChannelsKey : 1 as NSNumber,
            // 录音的质量
            AVEncoderAudioQualityKey : AVAudioQuality.Low.rawValue as NSNumber
        ]
    }
    
    func stopRecordng(){
        if (audioRecorder != nil) {
            if(audioRecorder!.recording){
                self.audioRecorder?.stop()
                println("Recording Stopped.")
            }
        }
    }
    
    func startRecording(){
        audioContext.switchRecord()
        audioContext.disableProximityMonitor()
        if let recorder = audioRecorder{
            
            recorder.delegate = self
            /* Prepare the recorder and then start the recording */
            
            if recorder.prepareToRecord() && recorder.recordForDuration(maxDuration){
                println("Successfully started to record.")
            } else {
                println("Failed to record.")
                audioRecorder = nil
            }
            
        } else {
            println("Failed to create an instance of the audio recorder")
        }
        
    }
    
}

