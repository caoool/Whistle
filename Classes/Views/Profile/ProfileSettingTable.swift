//
//  ProfileSettingView.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/13/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class ProfileSettingTable : UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func editName() {
        var alert = UIAlertController(title: "Name", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            text.placeholder = "Type your name"
        })
        alert.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { action in
            let textField = alert.textInputContextIdentifier
            let textFields:Array<UITextField>? =  alert.textFields as! Array<UITextField>?
            if textFields != nil {
                for textField:UITextField in textFields! {
                    self.nameLabel.text = textField.text
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func editPhone() {
        var alert = UIAlertController(title: "Phone Number", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            text.placeholder = "etc 408-666-6666"
        })
        alert.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { action in
            let textField = alert.textInputContextIdentifier
            let textFields:Array<UITextField>? =  alert.textFields as! Array<UITextField>?
            if textFields != nil {
                for textField:UITextField in textFields! {
                    self.phoneLabel.text = textField.text
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func editGender() {
        var alert = UIAlertController(title: "Gender", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Male", style: UIAlertActionStyle.Default, handler: { action in
            self.genderLabel.text = "Male"
        }))
        alert.addAction(UIAlertAction(title: "Female", style: UIAlertActionStyle.Default, handler: { action in
            self.genderLabel.text = "Female"
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func editStatus() {
        var alert = UIAlertController(title: "Status", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            text.placeholder = "Type your status"
        })
        alert.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { action in
            let textField = alert.textInputContextIdentifier
            let textFields:Array<UITextField>? =  alert.textFields as! Array<UITextField>?
            if textFields != nil {
                for textField:UITextField in textFields! {
                    
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            editProfilePhoto()
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            editName()
        }
        
        if indexPath.section == 0 && indexPath.row == 2 {
            editPhone()
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