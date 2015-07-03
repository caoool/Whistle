//
//  SetProfileView.swift
//  Whistle
//
//  Created by Yetian Mao on 6/25/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse


class SetProfileView: UITableViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    var user: PFUser?
    var rowCount : Int = 2
    
    private var imagePicker = UIImagePickerController()
    private var image : UIImage?
    private var name : String?
    private var email : String?
    private var needEdit : Bool = false
    
    let permissions = ["public_profile", "user_friends", "email", "user_photos"]
    
    required init(coder decoder: NSCoder) {
        user = PFUser.currentUser()
        super.init(coder: decoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()  
        self.imagePicker.delegate = self
        self.textField.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadScene", name: Constants.Notification.SetProfileView, object: nil)
        var tap = UITapGestureRecognizer(target: self, action: "tapToSeeOptions")
        self.profileImage.addGestureRecognizer(tap)
        self.profileImage.userInteractionEnabled = true
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.whiteColor()
        let query = PFUser.query()
        if PFFacebookUtils.isLinkedWithUser(user!) {
            VMGearLoadingView.showGearLoadingForView(self.view)
            self.needEdit = true
            getFBUserData()
        } else if PFTwitterUtils.isLinkedWithUser(user!) {
            VMGearLoadingView.showGearLoadingForView(self.view)
            self.needEdit = true
            getTwitterUserData()
        } else {
            self.rowCount = 5
            println("phone user")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func loadScene(){
        VMGearLoadingView.hideGearLoadingForView(self.view)
        self.textField.text = self.name
        self.profileImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.profileImage.image = Image.cropToSquare(image: self.image!)
        self.profileImage.layer.cornerRadius = self.profileImage.layer.frame.height/2
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.masksToBounds = true
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        if let user = self.user {
            self.editing = false
            VMGearLoadingView.showGearLoadingForView(self.view)
            var image : NSData
            if self.profileImage.image != nil {
                image = NSData(data: UIImagePNGRepresentation(self.profileImage.image!))
            } else {
                image = NSData(data: UIImagePNGRepresentation(UIImage(named: "default_user_photo")))
            }
            var fileImage = PFFile(name: "portrait.png", data: image)
            fileImage.saveInBackgroundWithBlock { (success : Bool, error : NSError?) -> Void in
                if success {
                    println("Image success")
                } else {
                    println("error" )
                }
            }
            if email != nil {
                user[Constants.User.Email] = self.email
            }
            
            user[Constants.User.Nickname] = textField.text
            user[Constants.User.Portrait] = fileImage
            user[Constants.User.Likes] = 0
            user[Constants.User.Dislikes] = 0
            user[Constants.User.Favors] = 0
            user[Constants.User.Assists] = 0
            user.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    println("success")
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: PFUser.currentUser()!.objectId!)
                    VMGearLoadingView.hideGearLoadingForView(self.view)
                    self.performSegueWithIdentifier("setProfileToInit", sender: self)
                }
            })
            user.pinInBackground()
        } else {
            performSegueWithIdentifier("setProfileToInit", sender: self)
        }
    }
    func getTwitterUserData(){
        var url : NSURL = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")!
        var request : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        PFTwitterUtils.twitter()?.signRequest(request)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(
            request,
            completionHandler: {
                data, response, error in
                if (error != nil) {
                    println("error")
                }
                var json = JSON(data: data)
                self.name = json["name"].string
                let url : String = json["profile_image_url"].string!
                ImageLoader.sharedLoader.imageForUrl(url, completionHandler:{(image: UIImage?, url: String) in
                    self.image = image
                    NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SetProfileView, object: self)
                })
        })
        task.resume()
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, picture.type(large)"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    //println(result)
                    let temp = result as! NSDictionary
                    self.email = temp.objectForKey("email") as? String
                    let url = temp.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String
                    ImageLoader.sharedLoader.imageForUrl(url, completionHandler:{(image: UIImage?, url: String) in
                        self.image = image
                        NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.SetProfileView, object: self)
                    })
                    self.name = result["name"] as? String
                }
            })
        }
    }
    
    func tapToSeeOptions() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        if needEdit {
            let edit = UIAlertAction(title: "Edit", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                println("Edit photo")
            })
            optionMenu.addAction(edit)
        }
        let takePhoto = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.shootPhoto()
            println("Shoot photo")
        })
        let chooseFromLibrary = UIAlertAction(title: "Choose from Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.photoFromLibrary()
            println("Choose From Library")
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(chooseFromLibrary)
        optionMenu.addAction(cancel)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: - Image
    //Start Photo Library
    func photoFromLibrary() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //take a picture, check if we have a camera first.
    func shootPhoto() {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraCaptureMode = .Photo
            presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            JSSAlertView().danger(self, title: "No Camera", text: "Sorry, this device has no camera", buttonText: "ok")
        }
    }
    
    //MARK: - Image Picker Delegates
    //What to do when the picker returns with a photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.profileImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.profileImage.image = Image.cropToSquare(image: chosenImage)
        self.profileImage.layer.cornerRadius = self.profileImage.layer.frame.height/2
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.masksToBounds = true
        self.needEdit = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Table View Delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowCount
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 3 {
            VMGearLoadingView.showGearLoadingForView(self.view)
            PFFacebookUtils.linkUserInBackground(self.user!, withReadPermissions: self.permissions, block: { (success, error) -> Void in
                if success {
                    println("success")
                    self.needEdit = true
                    self.rowCount = 2
                    self.getFBUserData()
                } else {
                    VMGearLoadingView.hideGearLoadingForView(self.view)
                    JSSAlertView().danger(self, title: "Network Error", text: "Please retry", buttonText: "ok")
                    println("error")
                }
            })
        }
        if indexPath.section == 0 && indexPath.row == 4 {
            VMGearLoadingView.showGearLoadingForView(self.view)
            PFTwitterUtils.linkUser(self.user!, block: { (success, error) -> Void in
                if success {
                    println("success")
                    self.needEdit = true
                    self.rowCount = 2
                    self.getTwitterUserData()
                } else {
                    JSSAlertView().danger(self, title: "Network Error", text: "Please retry", buttonText: "ok")
                    VMGearLoadingView.hideGearLoadingForView(self.view)
                    println("error")
                }
            })
        }
    }
}
