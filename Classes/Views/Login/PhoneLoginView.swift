//
//  PhoneLoginView.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Bolts
import Parse

class PhoneLoginView: UIViewController {
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var phoneNumber: String
    
    required init(coder aDecoder: NSCoder) {
        phoneNumber = ""
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        step1()
        sendCodeButton.layer.cornerRadius = 3
        
        self.editing = true
    }
    
    func step1() {
        phoneNumber = ""
        textField.placeholder = "555-333-6726"
        questionLabel.text = "Please enter your phone number to log in:"
        subtitleLabel.text = "This number is limited to 10-digit US numbers."
        sendCodeButton.enabled = true
    }
    
    func step2() {
        phoneNumber = textField.text
        textField.text = ""
        textField.placeholder = "1234"
        questionLabel.text = "Enter the 4-digit confirmation code:"
        subtitleLabel.text = "It was sent in an SMS message to +1" + phoneNumber
        sendCodeButton.enabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func didTapSendCodeButton() {
        if phoneNumber == "" {
            if count(textField.text) != 10 {
                println(count(textField.text))
                showAlert("Phone Login", message: "You must enter a 10-digit US phone number including area code.")
                return step1()
            }
            self.editing = false
            let params = ["phoneNumber" : textField.text]
            PFCloud.callFunctionInBackground("sendCode", withParameters: params) {
                (response: AnyObject?, error: NSError?) -> Void in
                self.editing = true
                if let error = error {
                    var description = error.description
                    if count(description) == 0 {
                        description = "There was a problem with the service.\nTry again later."
                    } else if let message = error.userInfo?["error"] as? String {
                        description = message
                    }
                    self.showAlert("Login Error", message: description)
                    return self.step1()
                }
                return self.step2()
            }
        } else {
            if let text = textField?.text, let code = text.toInt() {
                if count(text) == 4 {
                    return doLogin(phoneNumber, code: code)
                }
            }
            showAlert("Code Entry", message: "You must enter the 4 digit code texted to your phone number.")
        }
    }
    
    func doLogin(phoneNumber: String, code: Int) {
        self.editing = false
        let params = ["phoneNumber": phoneNumber, "codeEntry": code] as [NSObject:AnyObject]
        PFCloud.callFunctionInBackground("logIn", withParameters: params) {
            (response: AnyObject?, error: NSError?) -> Void in
            if let description = error?.description {
                self.editing = true
                return self.showAlert("Login Error", message: description)
            }
            if let token = response as? String {
                PFUser.becomeInBackground(token) { (user: PFUser?, error: NSError?) -> Void in
                    if let error = error {
                        self.showAlert("Login Error", message: "Something happened while trying to log in.\nPlease try again.")
                        self.editing = true
                        return self.step1()
                    }
                    self.performSegueWithIdentifier("phoneLoginToSetProfile", sender: self)
                }
            } else {
                self.editing = true
                self.showAlert("Login Error", message: "Something went wrong.  Please try again.")
                return self.step1()
            }
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        sendCodeButton.enabled = editing
        textField.enabled = editing
        if editing {
            textField.becomeFirstResponder()
        }
    }
    
    func showAlert(title: String, message: String) {
        return UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
}

extension PhoneLoginView : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.didTapSendCodeButton()
        
        return true
    }
}

