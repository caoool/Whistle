//
//  NewFavorTable.swift
//  Whistle
//
//  Created by Lu Cao on 6/26/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import Photos

class NewFavorTable: UITableViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var imageScrollViewCell: UITableViewCell!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var isaudioViewHidden: Bool = true {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var isImageScrollViewHidden: Bool = true {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Initialzations
    override func viewDidLoad() {
        super.viewDidLoad()

        addGestures()
        
        initAudioRecorder()
        initWaveformView()
        initRecordingView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        playerView.frame = audioView.frame
        
        println("cell: ")
        println(imageScrollViewCell.layer.frame)
        println("view: ")
        println(imageScrollView.layer.frame)
    }
    
    // MARK: - Record Audio

    private var hasRecording = false
    private var soundPlayer : AVAudioPlayer?
    private var soundRecorder : AVAudioRecorder?
    private var session : AVAudioSession?
    private var soundPath : String?
    
    private var waveformView = SiriWaveformView()
    private var recordingView = UIView()
    
    func initAudioRecorder() {
        soundPath = "\(NSTemporaryDirectory())test.wav"
        
        let url = NSURL(fileURLWithPath: soundPath!)
        
        session = AVAudioSession.sharedInstance()
        session?.setActive(true, error: nil)
        
        var error : NSError?
        
        session?.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        
        soundRecorder = AVAudioRecorder(URL: url, settings: nil, error: &error)
        soundRecorder?.meteringEnabled = true
        
        if(error != nil)
        {
            println("Error initializing the recorder: \(error)")
        }
        
        soundRecorder?.delegate = self
        soundRecorder?.prepareToRecord()
    }
    
    func initWaveformView() {
        var displaylink = CADisplayLink(target: self, selector: "updateWaveform")
        displaylink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        waveformView.primaryWaveLineWidth = 3.0
        waveformView.secondaryWaveLineWidth = 1.0
        
        waveformView.frame = UIScreen.mainScreen().applicationFrame
        waveformView.backgroundColor = UIColor.blackColor()
        waveformView.alpha = 0.75
    }
    
    func updateWaveform() {
        soundRecorder?.updateMeters()
        var normalizedValue = pow(10, soundRecorder!.averagePowerForChannel(0) / 20)
        waveformView.updateWithLevel(CGFloat(normalizedValue))
    }
    
    func initRecordingView() {
        // add waveform to this subview
        recordingView.addSubview(waveformView)
        
        // add label to this subview
        var label = UILabel(frame: CGRectMake(20, 0, 300, 21))
        println(UIScreen.mainScreen().applicationFrame.height)
        label.layer.frame.origin.y += 100
        label.textColor = UIColor.whiteColor()
        label.text = "Release finger to finish recording"
        recordingView.addSubview(label)
        recordingView.bringSubviewToFront(label)
    }
    
    func recordAudio() {
        session?.requestRecordPermission(){
            granted in
            if(granted == true)
            {
                self.soundRecorder?.record()
                
                // add waveform view
                var window = UIApplication.sharedApplication().delegate?.window
                window!?.addSubview(self.recordingView)
            }
            else
            {
                println("Unable to record")
            }
        }
    }
    
    func stopRecording() {
        soundRecorder?.stop()
        
        // remove waveform view
        recordingView.removeFromSuperview()
        hasRecording = true
        
        configAudio()
        configAudioView()
        
        isaudioViewHidden = false
    }
    
    // MARK: - Audio View
    
    var audioAsset = AVURLAsset()
    var playerView = SYWaveformPlayerView()
    
    func configAudio() {
        let url = NSURL(fileURLWithPath: soundPath!)
        audioAsset = AVURLAsset(URL: url, options: nil)
    }
    
    func configAudioView() {
        playerView.removeFromSuperview()
        playerView = SYWaveformPlayerView(frame: audioView.frame, asset: audioAsset, color: Constants.Color.AudioViewColor, progressColor: Constants.Color.AudioViewProgressColor)
        audioView.addSubview(playerView)
    }
    
    // MARK: - Image Scroller
    
    var images = [UIImage]()
    var imageViews = [UIImageView]()
    
    func configImages(selectedImages: [UIImage?]) {
        if selectedImages.count > 0 {
            for element in selectedImages {
                images.append(element!)
            }
        }
    }
    
    func configImageView() {
        if images.count == 0 {
            isImageScrollViewHidden = true
        } else {
            isImageScrollViewHidden = false
        }
        
        let scrollViewWidth: CGFloat = imageScrollView.frame.width
        let scrollViewHeight: CGFloat = imageScrollView.frame.height
        
        imageViews = [UIImageView]()
        for (index, element) in enumerate(images) {
            var imageView = UIImageView(image: element)
            imageView.frame = CGRectMake(scrollViewWidth*CGFloat(index), 0, scrollViewWidth, scrollViewHeight)
            imageView.userInteractionEnabled = true
            imageViews.append(imageView)
            imageScrollView.addSubview(imageView)
        }
        
        imageScrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(images.count), scrollViewHeight)
        imageScrollView.delegate = self
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
    }
    
    func reshapeImageView() {
        imageScrollView.frame = imageScrollViewCell.frame
        
        let scrollViewWidth: CGFloat = imageScrollView.frame.width
        let scrollViewHeight: CGFloat = imageScrollView.frame.height
        
        for (index, element) in enumerate(imageViews) {
            element.frame = CGRectMake(scrollViewWidth*CGFloat(index), 0, scrollViewWidth, scrollViewHeight)
        }
        
        imageScrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(images.count), scrollViewHeight)
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        
        // Test the offset and calculate the current page after scrolling ends
        var pageWidth: CGFloat = CGRectGetWidth(scrollView.frame)
        var currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        pageControl.currentPage = Int(currentPage)
        
        // center on content
        var newContentOffsetX = (CGFloat(pageControl.currentPage)) * scrollView.frame.width
        imageScrollView.contentOffset = CGPointMake(newContentOffsetX, 0)
    }
    
    // MARK: - IBActions

    @IBAction func privacyButtonTapped(sender: UIButton) {
        if sender.titleLabel?.text == "Public" {
            sender.setTitle("Friends", forState: UIControlState.Normal)
        } else {
            sender.setTitle("Public", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func deleteAudioButtonTapped(sender: UIButton) {
        isaudioViewHidden = true
    }
    
    @IBAction func addImageButtonTapped(sender: UIButton) {
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .NotDetermined {
            PHPhotoLibrary.requestAuthorization() { status in
            }
            
            return
        }
        
        if authorization == .Authorized {
            let presentImagePickerController: UIImagePickerControllerSourceType -> () = { source in
                let controller = UIImagePickerController()
                controller.delegate = self
                var sourceType = source
                if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
                    sourceType = .PhotoLibrary
                    println("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
                }
                controller.sourceType = sourceType
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
            
            let controller = ImagePickerSheetController()
            controller.addAction(ImageAction(title: NSLocalizedString("Take Photo", comment: "Action Title"), secondaryTitle: NSLocalizedString("Add Photo(s)", comment: "Action Title"), handler: { _ in
                presentImagePickerController(.Camera)
                }, secondaryHandler: { _, numberOfPhotos in
                    controller.getSelectedImagesWithCompletion() { images in
                        self.configImages(images)
                        self.configImageView()
                    }
            }))
            controller.addAction(ImageAction(title: NSLocalizedString("Photo Library", comment: "Action Title"), secondaryTitle: NSLocalizedString("Photo Library", comment: "Action Title"), handler: { _ in
                presentImagePickerController(.PhotoLibrary)
                }, secondaryHandler: { _, numberOfPhotos in
                    presentImagePickerController(.PhotoLibrary)
            }))
            controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: { _ in
                println("Cancelled")
            }))
            
            presentViewController(controller, animated: true, completion: nil)
        }
        else {
            let alertView = UIAlertView(title: NSLocalizedString("An error occurred", comment: "An error occurred"), message: NSLocalizedString("ImagePickerSheet needs access to the camera roll", comment: "ImagePickerSheet needs access to the camera roll"), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "OK"))
            alertView.show()
        }

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        images.append(image)
        configImageView()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteImageButtonTapped(sender: UIButton) {
        images.removeAtIndex(pageControl.currentPage)
        imageViews.removeAtIndex(pageControl.currentPage)
        configImageView()
    }
    
    
    // MARK: - Gesture
    
    func addGestures() {
        var tap = UITapGestureRecognizer(target: self, action: "respondToTapGesture:")
        tableView.addGestureRecognizer(tap)
        
        var buttonLongPressGuesture = UILongPressGestureRecognizer(target: self, action: "handleButtonLongPressGuesture:")
        recordButton.addGestureRecognizer(buttonLongPressGuesture)
    }
    
    func respondToTapGesture(gesture: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    func handleButtonLongPressGuesture(recognizer: UILongPressGestureRecognizer) {
        //as you hold the button this would fire
        if recognizer.state == UIGestureRecognizerState.Began {
            recordAudio()
        }
        
        // as you release the button this would fire
        if recognizer.state == UIGestureRecognizerState.Ended {
            stopRecording()
        }
    }
    
    // MARK: - Delegates
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        switch indexPath.section {
        case 0:
            if indexPath.row == 1 {
                return calculateHeightForString(addressLabel.text!) + 70
            } else {
                return 44
            }
        case 1:
            return 250
        case 2:
            if indexPath.row == 0 {
                return 250
            } else {
                return 44
            }
        case 3:
            if indexPath.row == 0 {
                return 60
            } else {
                return 44
            }
        case 4:
            if indexPath.row == 0 {
                return 60
            } else {
                return 250
            }
        default:
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return isaudioViewHidden ? 1 : 2
        case 4:
            return isImageScrollViewHidden ? 1 : 2
        default:
            return 0
        }
    }

    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}
