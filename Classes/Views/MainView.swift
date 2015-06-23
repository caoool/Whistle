//
//  MainView.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class MainView: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var setting1: UISwitch!
    @IBOutlet weak var setting2: UISwitch!
    @IBOutlet weak var setting3: UISwitch!
    
    @IBOutlet weak var saveSettingsButton: UIButton!
    
    var user: PFUser?
    
    required init(coder decoder: NSCoder) {
        user = PFUser.currentUser()
        
        super.init(coder: decoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        saveSettingsButton.layer.cornerRadius = 3
        if let user = self.user {
            usernameLabel.text = user.username
            if let name = user["name"] as? String {
                nameTextField.text = name
            }
            checkSettingsForUser(user)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func didTapLogOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func didTapSaveSettings(sender: AnyObject) {
        if let user = self.user {
            if nameTextField.text != "" {
                user["name"] = nameTextField.text
            }
            
            var image : NSData = NSData(data: UIImagePNGRepresentation(UIImage(named: "default_user_photo")))
            var fileImage = PFFile(name: "portrait.jpg", data: image)
            fileImage.saveInBackgroundWithBlock { (success : Bool, error : NSError?) -> Void in
                if success {
                    println("Image success")
                } else {
                    println("error" )
                }
            }
            user[Constants.User.Portrait] = fileImage
            
            user[Constants.User.Likes] = 0
            
            user[Constants.User.Dislikes] = 0
            
            user[Constants.User.Favors] = 0
            
            user[Constants.User.Assists] = 0
            
            if checkSetting(user, settingName: "setting1") != setting1.on {
                user["setting1"] = setting1.on
            }
            if checkSetting(user, settingName: "setting2") != setting2.on {
                user["setting2"] = setting2.on
            }
            if checkSetting(user, settingName: "setting3") != setting3.on {
                user["setting3"] = setting3.on
            }
            user.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    println("success")
                }
            })
            user.pinInBackground()
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func checkSetting(user: PFUser, settingName : String) -> Bool {
        if let value = user[settingName] as? Bool {
            return value
        }
        return false
    }
    
    func checkSettingsForUser(user: PFUser) {
        if checkSetting(user, settingName: "setting1") {
            setting1.setOn(true, animated: false)
        }
        if checkSetting(user, settingName: "setting2") {
            setting2.setOn(true, animated: false)
        }
        if checkSetting(user, settingName: "setting3") {
            setting3.setOn(true, animated: false)
        }
    }
}

extension MainView : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}
