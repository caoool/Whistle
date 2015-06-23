//
//  ProfileSettingView.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/13/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileSettingView : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Profile"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.topItem!.title = ""
        
    }
    
    func editProfilePhoto() {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("File Deleted")
        })
        
        let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("File Saved")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(chooseFromLibraryAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func edit() {
        let alert = UIAlertController(title: "Alert", message: "Using the alert controller",
            preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            println("File Saved")
        })
        
        let save = UIAlertAction(title: "Save", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("File Saved")
        })
        
        alert.addAction(cancel)
        alert.addAction(save)
            
        alert.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Sample text field"
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func editName() {
        let alert = SCLAlertView()
        let txt = alert.addTextField(title:"Enter your name")
        alert.addButton("Save") {
            println("Text value: \(txt.text)")
            var user : PFUser = PFUser.currentUser()!
            user["name"] = txt.text
            user.pinInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    println("saved locally success")
                }
            })
            user.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    println("success")
                }
            })
            
        }
        alert.showEdit("Name", subTitle: "Please Enter Your Name", closeButtonTitle: "Cancel", duration: 0.0)
    }
    
    func editGender() {
        let alert = SCLAlertView()
        alert.addButton("Male") {
            
        }
        alert.addButton("Famale") {
            println("Second button tapped")
        }
        alert.showInfo("Gender", subTitle: "Pick your gender", closeButtonTitle: "Cancel", duration: 0.0)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            editProfilePhoto()
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            editName()
        }
        
        if indexPath.section == 0 && indexPath.row == 2 {
            
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            editGender()
        }
        
        if indexPath.section == 1 && indexPath.row == 1 {
            
        }
        
        if indexPath.section == 1 && indexPath.row == 2 {
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    
    
    
    
    
}