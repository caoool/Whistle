//
//  NewFavorTable.swift
//  Whistle
//
//  Created by Lu Cao on 6/26/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//


//----------------------------------------------------------------------------------------------------------
import UIKit
import AVFoundation
import Foundation
import Photos
import Parse
//----------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------
class NewFavorTable: UITableViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate
//----------------------------------------------------------------------------------------------------------
{

    // MARK: - IBOutlets
    //----------------------------------------------------------------------------------------------------------
    // Location
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var locationIcon                             : UIImageView!
    @IBOutlet weak var locationLine                             : UIView!
    @IBOutlet weak var pickLocationButton                       : UIButton!
    @IBOutlet weak var privacyButton                            : UIButton!
    @IBOutlet weak var addressLabel                             : UILabel!
    //----------------------------------------------------------------------------------------------------------
    // Audio
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var audioIcon                                : UIImageView!
    @IBOutlet weak var audioLine                                : UIView!
    @IBOutlet weak var recordButton                             : UIButton!
    @IBOutlet weak var deleteAudioButton                        : UIButton!
    @IBOutlet weak var audioView                                : FSVoiceBubble!
    //----------------------------------------------------------------------------------------------------------
    // Favor
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var favorIcon                                : UIImageView!
    @IBOutlet weak var favorLine                                : UIView!
    @IBOutlet weak var favorHideButton                          : UIButton!
    @IBOutlet weak var favorTextView                            : UITextView!
    @IBOutlet weak var favorCharCountLabel                      : UILabel!
    //----------------------------------------------------------------------------------------------------------
    // Reward
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var rewardIcon                               : UIImageView!
    @IBOutlet weak var rewardLine                               : UIView!
    @IBOutlet weak var rewardHideButton                         : UIButton!
    @IBOutlet weak var rewardCharCountLabel                     : UILabel!
    @IBOutlet weak var rewardTextView                           : UITextView!
    //----------------------------------------------------------------------------------------------------------
    // Price
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var priceIcon                                : UIImageView!
    @IBOutlet weak var priceLine                                : UIView!
    @IBOutlet weak var plus1Button                              : UIButton!
    @IBOutlet weak var plus5Button                              : UIButton!
    @IBOutlet weak var plus10Button                             : UIButton!
    @IBOutlet weak var clearButton                              : UIButton!
    @IBOutlet weak var dollarLabel                              : UILabel!
    @IBOutlet weak var priceTextField                           : UITextField!
    @IBOutlet weak var priceBackView                            : UIView!
    //----------------------------------------------------------------------------------------------------------
    // Photos
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var photosIcon                               : UIImageView!
    @IBOutlet weak var photosLine                               : UIView!
    @IBOutlet weak var photo1                                   : UIImageView!
    @IBOutlet weak var photo2                                   : UIImageView!
    @IBOutlet weak var photo3                                   : UIImageView!
    @IBOutlet weak var photo4                                   : UIImageView!
    @IBOutlet weak var photo5                                   : UIImageView!
    @IBOutlet weak var photo6                                   : UIImageView!
    @IBOutlet weak var photo7                                   : UIImageView!
    @IBOutlet weak var photo8                                   : UIImageView!
    @IBOutlet weak var photo9                                   : UIImageView!
    @IBOutlet weak var photosParentView                         : UIView!
    @IBOutlet weak var photoCountLabel                          : UILabel!
    // Constraints
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var audioViewLengthCons                      : NSLayoutConstraint!
    //----------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Variables
    //----------------------------------------------------------------------------------------------------------
    private var waveformView                                    = SiriWaveformView()
    private var recordingView                                   = UIView()
    private var hasRecording                                    = false
    private var audioRecorder                                   : AudioRecorder = AudioRecorder()
    private var audioPlayer                                     : AudioPlayer = AudioPlayer()
    private var audioManager                                    : AudioManager = AudioManager()
    private var name                                            : NSString = "Recording"
    
    private var imageNum                                        : Int = 0 {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    private var addPhotoButton                                  = UIButton()
    private var deletePhotoButtons                              = [UIButton]()
    private var images                                          = [UIImage]()
    private var imageViews                                      = [UIImageView]()
    
    private var audioAsset                                      = AVURLAsset()
    private var playerView                                      = SYWaveformPlayerView()
    
    private var location                                        : PFGeoPoint?
    //----------------------------------------------------------------------------------------------------------
    private var favorContentIsHidden                            : Bool = false
    private var rewardContentIsHidden                           : Bool = false
    //----------------------------------------------------------------------------------------------------------
    private var isaudioViewHidden                               : Bool = true
    { didSet { tableView.reloadData() } }
    //----------------------------------------------------------------------------------------------------------
    private var isImageScrollViewHidden                         : Bool = true
    { didSet { tableView.reloadData() } }
    //----------------------------------------------------------------------------------------------------------

    
    // MARK: - Initialzations
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    //----------------------------------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        configLooks()
        
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        name = dateFormatter.stringFromDate(now)

        addGestures()
        audioRecorder.initRecorder(name)
        initWaveformView()
        initRecordingView()
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func viewWillAppear(animated: Bool)
    //----------------------------------------------------------------------------------------------------------
    {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLayoutSubviews()
    //----------------------------------------------------------------------------------------------------------
    {
        configShape()
    }
    
    
    // MARK: - IBActions
    //----------------------------------------------------------------------------------------------------------
    // START: - Tab Bar Items
    //----------------------------------------------------------------------------------------------------------
    @IBAction func send(sender: UIBarButtonItem)
    //----------------------------------------------------------------------------------------------------------
    {

        var favor : PFObject = PFObject(className: Constants.Favor.Name)
        var fileImage : PFFile
        var fileAudio : PFFile
        var index : Int = 0
        if self.images.count != 0 {
            for image in images {
                let data = NSData(data: UIImagePNGRepresentation(image))
                fileImage = PFFile(name: "picture.png", data: data)
                fileImage.saveInBackgroundWithBlock { (success : Bool, error : NSError?) -> Void in
                    if success {
                        println("Image success")
                    } else {
                        println("error" )
                    }
                }
                var imageObject = PFObject(className: Constants.Image.Name)
                imageObject[Constants.Image.File] = fileImage
                imageObject.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if error == nil {
                        println("Image saved")
                    }
                })
                favor.addObject(fileImage, forKey: Constants.Favor.Image)
            }
        }
        
        if let audio = audioManager.audioWithName(name)  {
            let fileAudio = PFFile(name: "Recording.m4a", data: audio)
            fileAudio.saveInBackgroundWithBlock { (success : Bool, error : NSError?) -> Void in
                if success {
                    println("Audio success")
                } else {
                    println("error" )
                }
            }
            favor[Constants.Favor.Audio] = fileAudio
        }
        
//        favor[Constants.Favor.Content] = self.contentTextView.text
        favor[Constants.Favor.Reward] = self.rewardTextView.text
        favor[Constants.Favor.Location] = location
        favor[Constants.Favor.Status] = 0
        favor[Constants.Favor.CreatedBy] = PFUser.currentUser()
        
        favor.saveInBackgroundWithBlock {
            (success : Bool, error : NSError?) -> Void in
            if (success) {
                println("Favor posted successfully")
                
            } else {
                println(error!.description)
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //----------------------------------------------------------------------------------------------------------
    @IBAction func cancel(sender: UIBarButtonItem)
    //----------------------------------------------------------------------------------------------------------
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //----------------------------------------------------------------------------------------------------------
    // END: - Tab Bar Items
    //----------------------------------------------------------------------------------------------------------
    
    //----------------------------------------------------------------------------------------------------------
    // START: - Location
    //----------------------------------------------------------------------------------------------------------
    @IBAction func goToMap(sender: UIButton)
    //----------------------------------------------------------------------------------------------------------
    {
        TableMapViewController.displayMapViewController(parentController: self, blockFinish: { (selectedAddress) -> () in
            println("mainView: \(selectedAddress.address)")
            self.addressLabel.text = selectedAddress.address
            self.location = PFGeoPoint(latitude: (selectedAddress.lat as NSString).doubleValue, longitude: (selectedAddress.lng as NSString).doubleValue)
            }) { () -> () in
        }
    }
   
    //----------------------------------------------------------------------------------------------------------
    @IBAction func privacyButtonTapped(sender: UIButton)
    //----------------------------------------------------------------------------------------------------------
    {
        if sender.titleLabel?.text == "  Public" {
            sender.setTitle("  Friends", forState: UIControlState.Normal)
        } else {
            sender.setTitle("  Public", forState: UIControlState.Normal)
        }
    }
    //----------------------------------------------------------------------------------------------------------
    // END: - Location
    //----------------------------------------------------------------------------------------------------------
    
    //----------------------------------------------------------------------------------------------------------
    // START: - Audio
    //----------------------------------------------------------------------------------------------------------
    @IBAction func deleteAudioButtonTapped(sender: UIButton)
    //----------------------------------------------------------------------------------------------------------
    {
        audioView.hidden = true
        sender.hidden = true
        
        hasRecording = false
        audioManager.removeAudioWithName(name)
    }
    //----------------------------------------------------------------------------------------------------------
    // END: - Audio
    //----------------------------------------------------------------------------------------------------------
    
    //----------------------------------------------------------------------------------------------------------
    // START: - Favor & Reward
    //----------------------------------------------------------------------------------------------------------
    @IBAction func toggleHidden(sender: UIButton)
    //----------------------------------------------------------------------------------------------------------
    {
        switch sender.tag {
        case 1:
            if favorContentIsHidden {
                favorHideButton.setTitle("Skip", forState: .Normal)
            } else {
                favorHideButton.setTitle("Compose", forState: .Normal)
            }
            favorContentIsHidden = !favorContentIsHidden
        case 2:
            if rewardContentIsHidden {
                rewardHideButton.setTitle("Skip", forState: .Normal)
            } else {
                rewardHideButton.setTitle("Compose", forState: .Normal)
            }
            rewardContentIsHidden = !rewardContentIsHidden
        default:
            break
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    //----------------------------------------------------------------------------------------------------------
    // END: - Favor
    //----------------------------------------------------------------------------------------------------------
    
    //----------------------------------------------------------------------------------------------------------
    // START: - Price
    //----------------------------------------------------------------------------------------------------------
    @IBAction func modifyPrice(sender: UIButton)
    //----------------------------------------------------------------------------------------------------------
    {
        bounceView(sender)
        bounceView(priceTextField)
        switch sender.titleLabel!.text! {
        case "C":
            priceTextField.text = ""
            priceTextField.font = UIFont(name: priceTextField.font.fontName, size: 15)
        case "+10":
            if priceTextField.text == "" {
                priceTextField.text = "10"
            } else {
                priceTextField.text = "\(priceTextField.text!.toInt()! + 10)"
            }
            priceTextField.font = UIFont(name: priceTextField.font.fontName, size: 19)
        case "+5":
            if priceTextField.text == "" {
                priceTextField.text = "5"
            } else {
                priceTextField.text = "\(priceTextField.text!.toInt()! + 5)"
            }
            priceTextField.font = UIFont(name: priceTextField.font.fontName, size: 19)
        case "+1":
            if priceTextField.text == "" {
                priceTextField.text = "1"
            } else {
                priceTextField.text = "\(priceTextField.text!.toInt()! + 1)"
            }
            priceTextField.font = UIFont(name: priceTextField.font.fontName, size: 19)
        default:
            return
        }
    }
    //----------------------------------------------------------------------------------------------------------
    // END: - Price
    //----------------------------------------------------------------------------------------------------------
    
    // MARK: - User Interactions
    //----------------------------------------------------------------------------------------------------------
    func addGestures()
    //----------------------------------------------------------------------------------------------------------
    {
        var tap = UITapGestureRecognizer(target: self, action: "respondToTapGesture:")
        tableView.addGestureRecognizer(tap)
        
        var buttonLongPressGuesture = UILongPressGestureRecognizer(target: self, action: "handleButtonLongPressGuesture:")
        recordButton.addGestureRecognizer(buttonLongPressGuesture)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func respondToTapGesture(gesture: UIGestureRecognizer)
    //----------------------------------------------------------------------------------------------------------
    {
        view.endEditing(true)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func handleButtonLongPressGuesture(recognizer: UILongPressGestureRecognizer)
    //----------------------------------------------------------------------------------------------------------
    {
        //as you hold the button this would fire
        if recognizer.state == UIGestureRecognizerState.Began {
            
            self.audioRecorder.startRecording()
            // add waveform view
            var window = UIApplication.sharedApplication().delegate?.window
            window!?.addSubview(self.recordingView)
        }
        
        // as you release the button this would fire
        if recognizer.state == UIGestureRecognizerState.Ended {
            self.audioRecorder.stopRecordng()
            // remove waveform view
            recordingView.removeFromSuperview()
            hasRecording = true
            
            configAudioView()
            isaudioViewHidden = false
        }
    }
    
    
    // MARK: - Functions
    //----------------------------------------------------------------------------------------------------------
    func configLooks()
    //----------------------------------------------------------------------------------------------------------
    {
        tableView.backgroundColor                                   = Constants.Color.Background
        tableView.contentInset                                      = UIEdgeInsetsMake(30, 0, 0, 0)
        
        var lines = [locationLine, audioLine, favorLine, rewardLine, priceLine, photosLine]
        for element in lines {
            element.backgroundColor                                 = Constants.Color.Border
        }
        
        var icons = [locationIcon, audioIcon, favorIcon, rewardIcon, priceIcon, photosIcon]
        for element in icons {
            tableView.bringSubviewToFront(element)
            element.layer.borderColor                               = Constants.Color.Border.CGColor
            element.layer.borderWidth                               = 2
            element.layer.cornerRadius                              = 35/2
            element.backgroundColor                                 = Constants.Color.Border
            let origImage                                           = element.image
            let tintedImage                                         = origImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            element.image                                           = tintedImage
            element.tintColor                                       = Constants.Color.Background
        }
        
        var buttons = [pickLocationButton, privacyButton]
        for element in buttons {
            element.setTitleColor(Constants.Color.TextLight, forState: .Normal)
            element.layer.backgroundColor = Constants.Color.ContentBackground.CGColor
            element.layer.cornerRadius = 12.5
        }
        
        var labels = [addressLabel, favorCharCountLabel, rewardCharCountLabel, photoCountLabel]
        for element in labels {
            element.textColor = Constants.Color.CellText
        }
        
        audioView.contentURL = NSBundle.mainBundle().URLForResource("Let It Go", withExtension: "mp3")
        audioView.durationInsideBubble                              = true
        audioView.bubbleImage                                       = UIImage(named: "fs_cap_bg")
        audioView.waveColor                                         = Constants.Color.Background
        audioView.animatingWaveColor                                = UIColor.grayColor()
        
        favorTextView.tag = 1
        rewardTextView.tag = 2
        var textViews = [favorTextView, rewardTextView]
        for element in textViews {
            element.delegate                                        = self
            element.textContainerInset                              = UIEdgeInsetsMake(10, 8, 10, 8)
            element.textColor                                       = Constants.Color.CellPlaceHolder
            element.layer.cornerRadius                              = 12
            element.layer.backgroundColor                           = Constants.Color.ContentBackground.CGColor
            if element.tag == 1 {
                println("Set")
                element.text                                        = Constants.PlaceHolder.NewFavor
            }
            if element.tag == 2 {
                element.text                                        = Constants.PlaceHolder.NewReward
            }
        }
        
        favorHideButton.tag = 1
        rewardHideButton.tag = 2
        var hideButtons = [favorHideButton, rewardHideButton]
        for element in hideButtons {
            element.setTitleColor(Constants.Color.CellText, forState: .Normal)
        }
        
        priceTextField.delegate                                     = self
        dollarLabel.textColor                                       = Constants.Color.ContentBackground
        priceTextField.textColor                                    = Constants.Color.Background
        priceTextField.font                                         = UIFont(name: priceTextField.font.fontName, size: 15)
        priceBackView.layer.backgroundColor                         = Constants.Color.CellText.CGColor
        
        imageViews = [photo1, photo2, photo3, photo4, photo5, photo6, photo7, photo8, photo9]
        for element in imageViews {
            element.layer.borderColor                               = Constants.Color.ContentBackground.CGColor
            element.layer.borderWidth                               = 1
            element.layer.cornerRadius                              = 8
            element.alpha                                           = 0
            element.clipsToBounds                                   = true
            var deleteButton                                        = UIButton(frame: CGRectMake(0, 0, 22, 22))
            deleteButton.layer.cornerRadius                         = 11
            deleteButton.setImage(UIImage(named: "favor_new_delete"), forState: .Normal)
            deleteButton.addTarget(self, action: "deletePhoto:", forControlEvents: .TouchUpInside)
            let deletePhotoOrigImage                                = deleteButton.imageView?.image
            let deletePhotoTintedImage                              = deletePhotoOrigImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            deleteButton.setImage(deletePhotoTintedImage, forState: .Normal)
            deleteButton.tintColor                                  = Constants.Color.CellText
            deleteButton.backgroundColor                            = Constants.Color.ContentBackground
            deleteButton.alpha                                      = 0
            photosParentView.addSubview(deleteButton)
            deletePhotoButtons.append(deleteButton)
        }
        
        addPhotoButton                                              = UIButton(frame: CGRectZero)
        addPhotoButton.clipsToBounds                                = true
        addPhotoButton.setImage(UIImage(named: "favor_new_add_photo"), forState: .Normal)
        addPhotoButton.addTarget(self, action: "addPhoto", forControlEvents: .TouchUpInside)
        addPhotoButton.layer.cornerRadius                           = 8
        let addPhotoOrigImage                                       = addPhotoButton.imageView?.image
        let addPhotoTintedImage                                     = addPhotoOrigImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        addPhotoButton.setImage(addPhotoTintedImage, forState: .Normal)
        addPhotoButton.tintColor                                    = Constants.Color.CellText
        addPhotoButton.backgroundColor                              = Constants.Color.ContentBackground
        photosParentView.addSubview(addPhotoButton)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configShape()
    //----------------------------------------------------------------------------------------------------------
    {
        var buttonList = [recordButton]
        for element in buttonList {
            element.layer.cornerRadius                             = element.layer.frame.height/2
            element.backgroundColor                                = Constants.Color.Border
            let origImage                                          = element.imageView?.image
            let tintedImage                                        = origImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            element.setImage(tintedImage, forState: .Normal)
            element.tintColor                                      = Constants.Color.Background
        }
        
        var priceButtonList = [plus1Button, plus5Button, plus10Button, clearButton]
        for element in priceButtonList {
            element.layer.borderColor                               = Constants.Color.Border.CGColor
            element.layer.borderWidth                               = 0.3
            element.layer.cornerRadius                              = element.layer.frame.height/2
            element.setTitleColor(Constants.Color.CellText, forState: .Normal)
        }
        
        priceBackView.layer.cornerRadius                            = priceTextField.layer.frame.height/2
        
        if imageNum == 0 {
            addPhotoButton.layer.frame = imageViews[imageNum].layer.frame
            addPhotoButton.layer.frame.origin = imageViews[imageNum].layer.frame.origin
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    // START: - Record Audio
    //----------------------------------------------------------------------------------------------------------
    func initWaveformView()
    //----------------------------------------------------------------------------------------------------------
    {
        var displaylink = CADisplayLink(target: self, selector: "updateWaveform")
        displaylink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        waveformView.primaryWaveLineWidth = 3.0
        waveformView.secondaryWaveLineWidth = 1.0
        
        waveformView.frame = UIScreen.mainScreen().applicationFrame
        waveformView.backgroundColor = UIColor.blackColor()
        waveformView.alpha = 0.75
    }
    
    //----------------------------------------------------------------------------------------------------------
    func updateWaveform()
    //----------------------------------------------------------------------------------------------------------
    {
        self.audioRecorder.audioRecorder?.updateMeters()
        var normalizedValue = pow(10, self.audioRecorder.audioRecorder!.averagePowerForChannel(0) / 20)
        waveformView.updateWithLevel(CGFloat(normalizedValue))
    }
    
    //----------------------------------------------------------------------------------------------------------
    func initRecordingView()
    //----------------------------------------------------------------------------------------------------------
    {
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
    //----------------------------------------------------------------------------------------------------------
    // END: - Record Audio
    //----------------------------------------------------------------------------------------------------------
    
    
    //----------------------------------------------------------------------------------------------------------
    // START: - Audio View
    //----------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------
    func configAudioView()
    //----------------------------------------------------------------------------------------------------------
    {
        
    }
    //----------------------------------------------------------------------------------------------------------
    // END: - Audio View
    //----------------------------------------------------------------------------------------------------------
    
    //----------------------------------------------------------------------------------------------------------
    // START: - Photos
    //----------------------------------------------------------------------------------------------------------
    func addPhoto()
    //----------------------------------------------------------------------------------------------------------
    {
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
                        self.configImageView(images)
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
    
    //----------------------------------------------------------------------------------------------------------
    func configImageView(selectedImages: [UIImage?])
    //----------------------------------------------------------------------------------------------------------
    {
        for element in selectedImages {
            if imageNum < 8 {
                imageViews[imageNum].image                              = element
                imageViews[imageNum].alpha                              = 1
                
                deletePhotoButtons[imageNum].alpha                      = 1
                deletePhotoButtons[imageNum].layer.frame.origin         = CGPointMake(imageViews[imageNum].layer.frame.origin.x - 5, imageViews[imageNum].layer.frame.origin.y - 5)
                deletePhotoButtons[imageNum].tag                        = imageNum
                
                imageNum++
                addPhotoButton.layer.frame                              = imageViews[imageNum].layer.frame
                addPhotoButton.layer.frame.origin                       = imageViews[imageNum].layer.frame.origin
            } else if imageNum < 9 {
                imageViews[imageNum].image                              = element
                imageViews[imageNum].alpha                              = 1
                
                deletePhotoButtons[imageNum].alpha                      = 1
                deletePhotoButtons[imageNum].layer.frame.origin         = CGPointMake(imageViews[imageNum].layer.frame.origin.x - 5, imageViews[imageNum].layer.frame.origin.y - 5)
                deletePhotoButtons[imageNum].tag                        = imageNum
                
                imageNum++
                addPhotoButton.alpha                                    = 0
            }
            photoCountLabel.text                                        = "\(imageNum)/9"
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    func deletePhoto(sender: UIButton)
    //----------------------------------------------------------------------------------------------------------
    {
        imageNum--
        imageViews[imageNum].alpha                     = 0
        deletePhotoButtons[imageNum].alpha             = 0
        addPhotoButton.alpha                           = 1
        addPhotoButton.layer.frame                     = imageViews[imageNum].layer.frame
        addPhotoButton.layer.frame.origin              = imageViews[imageNum].layer.frame.origin
        photoCountLabel.text                           = "\(imageNum)/9"
        for index in sender.tag...imageNum {
            imageViews[index].image = imageViews[index+1].image
        }
    }
    //----------------------------------------------------------------------------------------------------------
    // END: - Photos
    //----------------------------------------------------------------------------------------------------------
    
    // MARK: - Delegates
    //----------------------------------------------------------------------------------------------------------
    // Modify cell height and background color
    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    //----------------------------------------------------------------------------------------------------------
    {
        var cell                                            = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.backgroundColor                                = Constants.Color.Background
        return cell
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //----------------------------------------------------------------------------------------------------------
    {
        switch indexPath.section {
        case 0:                                             // Location
            return calculateHeightForString(addressLabel.text!) + 150
        case 1:                                             // Audio
            return 150
        case 2:                                             // Favor
            return favorContentIsHidden ? 60 : 250
        case 3:                                             // Reward
            return rewardContentIsHidden ? 60 : 250
        case 4:                                             // Price
            return 100
        case 5:                                             // Photos
            var rows: CGFloat?
            switch imageNum {
            case 0...2:
                rows = 1
            case 3...5:
                rows = 2
            case 6...9:
                rows = 3
            default:
                break
            }
            var imageViewsHeight = 100 + 100 * rows!
            return imageViewsHeight
        default:
            return 44
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    func textViewDidBeginEditing(textView: UITextView)
    //----------------------------------------------------------------------------------------------------------
    {
        println(textView.text)
        if textView.tag == 1 {
            if textView.text == Constants.PlaceHolder.NewFavor {
                println("123")
                textView.text = ""
                textView.textColor = Constants.Color.CellText
            }
        }
        if textView.tag == 2 {
            if textView.text == Constants.PlaceHolder.NewReward {
                textView.text = ""
                textView.textColor = Constants.Color.CellText
            }
        }
        textView.becomeFirstResponder()
    }
    
    //----------------------------------------------------------------------------------------------------------
    func textViewDidEndEditing(textView: UITextView)
    //----------------------------------------------------------------------------------------------------------
    {
        if textView.tag == 1 {
            if textView.text == "" {
                textView.text = Constants.PlaceHolder.NewFavor
                textView.textColor = Constants.Color.CellPlaceHolder
            }
        }
        if textView.tag == 2 {
            if textView.text == "" {
                textView.text = Constants.PlaceHolder.NewReward
                textView.textColor = Constants.Color.CellPlaceHolder
            }
        }
        textView.resignFirstResponder()
    }
    
    //----------------------------------------------------------------------------------------------------------
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    //----------------------------------------------------------------------------------------------------------
    {
        let num: Int = count(textView.text)
        if textView.tag == 1 {                                      // Favor
            if num - range.length + count(text) > Constants.Limit.Favor {
                return false
            } else {
                favorCharCountLabel.text = "\(num - range.length + count(text))/\(Constants.Limit.Favor)"
                return true
            }
        }
        if textView.tag == 2 {                                      // Reward
            if num - range.length + count(text) > Constants.Limit.Reward {
                return false
            } else {
                rewardCharCountLabel.text = "\(num - range.length + count(text))/\(Constants.Limit.Reward)"
                return true
            }
        }
        return true
    }

    //----------------------------------------------------------------------------------------------------------
    func textFieldDidBeginEditing(textField: UITextField)
    //----------------------------------------------------------------------------------------------------------
    {
        priceTextField.font = UIFont(name: priceTextField.font.fontName, size: 19)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func textFieldDidEndEditing(textField: UITextField)
    //----------------------------------------------------------------------------------------------------------
    {
        if textField.text == "" {
            priceTextField.font = UIFont(name: priceTextField.font.fontName, size: 15)
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func scrollViewWillBeginDragging(scrollView: UIScrollView)
    //----------------------------------------------------------------------------------------------------------
    {
        view.endEditing(true)
    }
    
}










