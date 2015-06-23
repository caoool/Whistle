//
//  AlertController.swift
//  Arrived
//
//  Created by Lu Cao on 5/25/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class AlertController: SimpleAlert.Controller {
    override func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField!) -> Void)? = nil) {
        super.addTextFieldWithConfigurationHandler() { textField in
            textField.frame.size.height = 33
            textField.backgroundColor = UIColorFromHex(0x3D4656, alpha: 0.3)
            textField.layer.borderColor = UIColor.whiteColor().CGColor
            textField.layer.borderWidth = 0.3
            textField.tintColor = UIColorFromHex(0x3D4656, alpha: 0.9)
            textField.font = UIFont(name: "American Typewriter", size: 17)
            textField.textColor = UIColorFromHex(0x3D4656, alpha: 0.9)
            
            configurationHandler?(textField)
        }
    }
    
    override func configurButton(style :SimpleAlert.Action.Style, forButton button: UIButton) {
        super.configurButton(style, forButton: button)
        
        if let font = button.titleLabel?.font {
            switch style {
            case .OK:
                button.titleLabel?.font = UIFont(name: "American Typewriter", size: 19)
                button.setTitleColor(UIColor.grayColor(), forState: .Normal)
            case .Cancel:
                button.titleLabel?.font = UIFont(name: "American Typewriter", size: 19)
                button.backgroundColor = UIColorFromHex(0x54C799, alpha: 0.65)
                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            case .Destructive:
                button.titleLabel?.font = UIFont(name: "American Typewriter", size: 19)
                button.backgroundColor = UIColorFromHex(0x54C799, alpha: 0.65)
                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            case .Default:
                button.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configContentView = { [weak self] view in
            if let view = view as? SimpleAlert.ContentView {
                view.layer.backgroundColor = UIColorFromHex(0xFFFFFF, alpha: 0.95).CGColor
                view.titleLabel.textColor = UIColorFromHex(0x3D4656, alpha: 0.9)
                view.titleLabel.font = UIFont(name: "American Typewriter", size: 26)
                view.messageLabel.textColor = UIColorFromHex(0x474E5D, alpha: 0.9)
                view.messageLabel.font = UIFont(name: "American Typewriter", size: 12)
                view.messageLabel.textAlignment = .Left
                view.textBackgroundView.layer.backgroundColor = UIColorFromHex(0xFFFFFF, alpha: 0.1).CGColor
                view.textBackgroundView.layer.cornerRadius = 3.0
                view.textBackgroundView.clipsToBounds = true
            }
        }
    }
}