//
//  NewFavorView.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse



class NewFavorView : UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    
    @IBOutlet weak var favorStartTime: UITextField!
    @IBOutlet weak var favorEffectiveLength: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageButton: UIBarButtonItem!
    
    // Audio
    private var waveformView = SiriWaveformView()
    private var recordingView = UIView()
    private var hasRecording = false
    private var audioRecorder : AudioRecorder = AudioRecorder()
    private var audioPlayer : AudioPlayer = AudioPlayer()
    private var audioManager : AudioManager = AudioManager()
    private var name : NSString = "Recording"
    private var label = UILabel()
    private var button = UIButton()
    
    // Images
    private var imagePicker = UIImagePickerController()
    private var addImage = UIImageView()
    private var imageViews : [UIImageView] = [UIImageView]()
    private var images : [NSData] = [NSData]()
    
    // Text View PlaceHolder
    private var placeHolder : UILabel = UILabel()
    
    // Current Location
    private var currentLocation : PFGeoPoint? = nil
    
    // Selected Tags
    private var tags : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        self.textView.delegate = self
        self.textView.becomeFirstResponder()
        
        self.placeHolder = UILabel(frame: CGRectMake(5, 0, self.textView.frame.size.width - 10.0, 34.0))
        self.placeHolder.backgroundColor = UIColor.clearColor()
        self.placeHolder.textColor = UIColor.grayColor()
        self.placeHolder.font = UIFont(name: "System", size: 14.0)
        self.placeHolder.text = Constants.Favor.PlaceHolder
        self.textView.addSubview(placeHolder)
        // Add addImage Button to the ImageViews
        imageViews.append(self.addImage)
        audioRecorder.initRecorder(name)
        initWaveformView()
        initRecordingView()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.textView.becomeFirstResponder()
        if imageViews.count == 4 {
            imageButton.enabled = false
        } else {
            imageButton.enabled = true
        }
    }
    
    //MARK: IBActions
    
    @IBAction func sendFavor(sender: UIBarButtonItem) {
        
        FavorBackend.postFavor(textView.text, images: images, audio: audioManager.audioWithName(name), location: currentLocation, tags: tags)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickStartTime(sender: UIButton) {
        
        let datePicker : UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        self.favorStartTime.inputView = datePicker
        
    }
    
    @IBAction func setEffectiveLenght(sender: UIButton) {
    }
    
    @IBAction func goToMap(sender: UIBarButtonItem) {
        TableMapViewController.displayMapViewController(parentController: self, blockFinish: { (selectedAddress) -> () in
            println("mainView: \(selectedAddress.address)")
            self.currentLocation = PFGeoPoint(latitude: (selectedAddress.lat as NSString).doubleValue, longitude: (selectedAddress.lng as NSString).doubleValue)
            }) { () -> () in
        }
    }
    
    @IBAction func addTimeConstraint(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        
        
    }
    
    @IBAction func showTags(sender: UIBarButtonItem) {
        
        RRTagController.displayTagController(parentController: self, tagsString: test.tags,
            blockFinish: { (selectedTags, unSelectedTags) -> () in
                
                for tag in selectedTags {
                    self.tags.append(tag.textContent)
                }
                
                // the user finished the selection and returns the separated list Selected and not selected.
            }) { () -> () in
                // here the user cancel the selection, nothing is returned.
        }
    }
    
    @IBAction func showAudioButton(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        createRecordButton()
    }
    
    //Start Photo Library
    @IBAction func photoFromLibrary(sender: UIBarButtonItem) {
        imagePicker.allowsEditing = false //2
        imagePicker.sourceType = .PhotoLibrary //3
        imagePicker.modalPresentationStyle = .Popover
        presentViewController(imagePicker, animated: true, completion: nil)//4
        imagePicker.popoverPresentationController?.barButtonItem = sender
    }
    
    //take a picture, check if we have a camera first.
    @IBAction func shootPhoto(sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraCaptureMode = .Photo
            presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    //MARK: - Util Methods
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func initWaveformView() {
        var displaylink = CADisplayLink(target: self, selector: "updateWaveform")
        displaylink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        waveformView.waveColor = UIColor.greenColor()
        waveformView.primaryWaveLineWidth = 3.0
        waveformView.secondaryWaveLineWidth = 1.0
        waveformView.frame = self.view.frame
        waveformView.backgroundColor = UIColor.blackColor()
        waveformView.alpha = 0.75
    }
    
    func updateWaveform() {
        self.audioRecorder.audioRecorder?.updateMeters()
        var normalizedValue = pow(10, self.audioRecorder.audioRecorder!.averagePowerForChannel(0) / 20)
        waveformView.updateWithLevel(CGFloat(normalizedValue))
    }
    
    func initRecordingView() {
        // add waveform to this subview
        recordingView.addSubview(waveformView)
        
        // add label to this subview
        var label = UILabel(frame: CGRectMake(0, 0, 300, 21))
        label.center.y = self.view.center.y - 65
        label.textColor = UIColor.greenColor()
        
        // label.textAlignment = NSTextAlignment.Center
        label.text = "Release finger to finish recording"
        recordingView.addSubview(label)
        recordingView.bringSubviewToFront(label)
    }
    
    //MARK: UI Methods
    
    //Compose nine image view
    func imageViewComposer(chosenImage: UIImage){
        
        let imageView = UIImageView(image: Image.cropToSquare(image: chosenImage))
        let buttonImage = UIImage(named: "favor_photo_add")
        var x1 = buttonImage!.size.width/2 + 20
        var x2 = self.view.frame.width/2
        var x3 = self.view.frame.width - buttonImage!.size.width/2 - 20
        var y1 = self.view.center.y - 50
        var y2 = y1 + buttonImage!.size.width + 20
        var y3 = y2 + buttonImage!.size.width + 20
        var centers : [CGPoint] = [CGPointMake(x1, y1), CGPointMake(x2, y1), CGPointMake(x3, y1),
                                   CGPointMake(x1, y2), CGPointMake(x2, y2), CGPointMake(x3, y2),
                                   CGPointMake(x1, y3), CGPointMake(x2, y3), CGPointMake(x3, y3)]
            
        if imageViews.count < 3 {
            addImage.frame = CGRectMake(0, 0, buttonImage!.size.height, buttonImage!.size.width)
            addImage.image = buttonImage
            addImage.center = centers[imageViews.count]
            addImage.userInteractionEnabled = true
            self.view.addSubview(addImage)
            let tap = UITapGestureRecognizer(target: self, action: Selector("addImage:"))
            tap.numberOfTapsRequired = 1
            tap.delegate = self
            addImage.addGestureRecognizer(tap)
        } else {
            addImage.removeFromSuperview()
        }
        
        imageView.contentMode = .ScaleAspectFit
        imageView.frame = CGRectMake(0, 0, buttonImage!.size.height, buttonImage!.size.width)
        imageView.center = centers[imageViews.count - 1]
        imageView.userInteractionEnabled = true
        
        let delete = createDeleteButton(imageView.frame.width, actionName: "deleteImage:")
        self.view.addSubview(imageView)
        imageView.addSubview(delete)
        imageViews.insert(imageView, atIndex: imageViews.count - 1)
        println(imageViews.count)
    }
    
    func createDeleteButton(width : CGFloat, actionName : Selector) -> UIButton{
        let delete = UIButton()
        let deleteImage = UIImage(named: "favor_photo_delete")
        delete.frame = CGRectMake(0, 0, deleteImage!.size.height, deleteImage!.size.width)
        delete.setImage(deleteImage, forState: UIControlState.Normal)
        delete.center = CGPointMake(width - delete.frame.width/2 , delete.frame.height/2 )
        delete.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: actionName)
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        delete.addGestureRecognizer(tap)
        return delete
    }
    
    //Create Auido Recording Button
    func createRecordButton () {
        let mic = UIImage(named: "favor_mic")
        label.text = "Tap and Hold to Record"
        label.font = UIFont(name: "System", size: 14.0)
        label.textColor = UIColor.grayColor()
        label.textAlignment = NSTextAlignment.Center
        label.frame = CGRectMake(0.0, 0.0, 200, 20)
        label.center = CGPointMake(self.view.center.x, self.view.frame.height - label.frame.size.height + 5)
        button.frame = CGRectMake(0.0, 0.0, mic!.size.height, mic!.size.height)
        button.setImage(mic, forState: UIControlState.Normal)
        button.center = CGPointMake(self.view.center.x, self.view.frame.height - mic!.size.height)
        var longPressGuesture = UILongPressGestureRecognizer(target: self, action: "longPressToRecord:")
        button.addGestureRecognizer(longPressGuesture)
        self.view.addSubview(button)
        self.view.addSubview(label)
    }
    
    func createPlayButton () {
        let play = UIImage(named: "favor_play")
        button.frame = CGRectMake(0.0, 0.0, play!.size.height, play!.size.height)
        button.setImage(play, forState: UIControlState.Normal)
        button.center = CGPointMake(self.view.center.x, self.view.frame.height - play!.size.height)
        var tapGuesture = UITapGestureRecognizer(target: self, action: "tapToPlay:")
        button.addGestureRecognizer(tapGuesture)
        let delete = createDeleteButton(button.frame.width, actionName: "deleteAudio:")
        button.addSubview(delete)
        self.view.addSubview(button)
    }
    
    //MARK: Tap Gesture Handlers
    
    func addImage(sender:UIButton!){
        imagePicker.allowsEditing = false //2
        imagePicker.sourceType = .PhotoLibrary //3
        imagePicker.modalPresentationStyle = .Popover
        presentViewController(imagePicker, animated: true, completion: nil)//4
    }
    
    func deleteImage(sender: UITapGestureRecognizer?){
        var index = 0
        var i = imageViews.count - 1
        while index < imageViews.count - 1{
            println("in while index: \(index)")
            if sender!.view!.superview!.isEqual(imageViews[index]) {
                UIView.animateWithDuration(1.0, animations: {
                    while i > index {
                        self.imageViews[i].center = self.imageViews[i-1].center
                        i = i - 1
                    }
                })
                break
            }
            index = index + 1
        }
        imageViews.removeAtIndex(index)
        sender?.view?.superview?.removeFromSuperview()
        println(imageViews.count)
        if (imageViews.count < 3) {
            imageButton.enabled = true
        }
    }
    
    func longPressToRecord(sender: UILongPressGestureRecognizer!) {
        //as you hold the button this would fire
        if sender.state == UIGestureRecognizerState.Began {
            println("holding")
            
            //start recording
            self.view.addSubview(self.recordingView)
            self.view.bringSubviewToFront(sender.view!)
            self.audioRecorder.startRecording()
        }
        
        // as you release the button this would fire
        if sender.state == UIGestureRecognizerState.Ended {
            println("released")
            self.audioRecorder.stopRecordng()
            audioManager.audioWithName(name)
            
            // remove waveform view
            recordingView.removeFromSuperview()
            hasRecording = true
            
            sender.view?.removeFromSuperview()
            createPlayButton()
            label.text = "Tap to Play"
        }
    }
    
    func tapToPlay(sender: UITapGestureRecognizer!){
        let path = audioManager.audioURLWithName(name)
        self.audioPlayer.playAudio(path)
    }
    
    func deleteAudio(sender: UITapGestureRecognizer!){
        hasRecording = false
        sender?.view?.superview?.removeFromSuperview()
        sender?.view?.removeFromSuperview()
        label.text = "Tap and Hold to Record"
        createRecordButton()
        audioManager.removeAudioWithName(name)
    }
    
    //MARK: - Image Picker Delegates
    //What to do when the picker returns with a photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        images.append(NSData(data: UIImagePNGRepresentation(chosenImage)))
        imageViewComposer(chosenImage)
        dismissViewControllerAnimated(true, completion: nil)
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
