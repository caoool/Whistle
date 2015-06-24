//
//  HelperMethods.swift
//  Arrived
//
//  Created by Lu Cao on 4/25/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import Foundation
import UIKit

// display alert in current viewcontroller
func displayAlert(title: String, message: String) {
    
    let alertController = UIAlertController(title: title,
        message: message,
        preferredStyle: UIAlertControllerStyle.Alert)
    
    alertController.addAction(UIAlertAction(title: "Dismiss",
        style: UIAlertActionStyle.Default,
        handler: nil))
    
    var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
    
    if topController != nil {
        while topController!.presentedViewController != nil {
            topController = topController!.presentedViewController
        }
    }
    
    topController!.presentViewController(alertController, animated: true, completion: nil)
    
    //    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController?.presentViewController(alertController, animated: true, completion: nil)
}

// check error code, if code = 20000, no error and return true
func checkErrorCodeInDictionary(dict: Dictionary<String, AnyObject>?) -> Bool {
    if let code = dict!["code"] as? String {
        if code == "20000" {
            println("Code = 20000, no error")
            return true
        } else {
            displayAlert("Data error", dict!["message"] as! String)
            return false
        }
    } else {
        println("Can not get code from dictionary")
        return false
    }
}


// add a leftview which is an icon to a uitextview
func addIconToUITextFieldLeftView(textField: UITextField, imageName: String) {
    var imageView = UIImageView(image: UIImage(named: imageName))
    textField.leftViewMode = .Always
    imageView.frame = CGRect(x: 0, y: 0, width: textField.frame.height*0.8, height: textField.frame.height*0.8)
    textField.leftView = imageView
}

/**
Validate phone number
*/
func phoneNumberValidation(value: String) -> Bool {
    var charcter  = NSCharacterSet(charactersInString: "0123456789").invertedSet
    var filtered:NSString!
    var inputString:NSArray = value.componentsSeparatedByCharactersInSet(charcter)
    filtered = inputString.componentsJoinedByString("")
    return  value == filtered
}

/**
Detect credit card type
*/
class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        var error: NSError?
        self.internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)!
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, count(input)))
        return matches.count > 0
    }
}

func detectCreditCardType(num: String) -> String {
    
    if Regex("^4[0-9]{12}(?:[0-9]{3})?$").test(num) {
        return "Visa"
    } else if Regex("^5[1-5][0-9]{14}$").test(num) {
        return "MasterCard"
    } else if Regex("^3[47][0-9]{13}$").test(num) {
        return "American Express"
    } else if Regex("^6(?:011|5[0-9]{2})[0-9]{12}$").test(num) {
        return "Discover"
    } else if Regex("^(?:2131|1800|35[0-9]{3})[0-9]{11}").test(num) {
        return "JCB"
    } else {
        return "Invalid"
    }
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.addAnimation(rotateAnimation, forKey: nil)
    }
}

extension UIImage {
    var rounded: UIImage {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = size.height < size.width ? size.height/2 : size.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage {
        let square = size.width < size.height ? CGSize(width: size.width, height: size.width) : CGSize(width: size.height, height: size.height)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}


func bounceView(myView: UIView) {
    myView.transform = CGAffineTransformMakeScale(0.1, 0.1)
    UIView.animateWithDuration(2.0,
        delay: 0,
        usingSpringWithDamping: 0.2,
        initialSpringVelocity: 6.0,
        options: UIViewAnimationOptions.AllowUserInteraction,
        animations: {
            myView.transform = CGAffineTransformIdentity
        }, completion: nil)
}

func fadeInView(myView: UIView, t: NSTimeInterval) {
    UIView.animateWithDuration(t, animations: {
        myView.alpha = 1.0
    })
}

func fadeOutView(myView: UIView, t: NSTimeInterval) {
    UIView.animateWithDuration(t, animations: {
        myView.alpha = 0
    })
}

/**
rounded corner for only certain sides of the frame
*/
extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}

func roundedWithWhiteBorder(myView: UIView, width: CGFloat) {
    myView.layer.borderWidth = width
    myView.layer.masksToBounds = true
    myView.layer.borderColor = UIColorFromHex(0xFFFFFF, alpha: 1).CGColor
    myView.layer.cornerRadius = myView.frame.height/2
    myView.clipsToBounds = true
}

func calculateHeightForString(inString:String) -> CGFloat
{
    var messageString = inString
    var attributes = [UIFont(): UIFont.systemFontOfSize(15.0)]
    var attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: attributes)
    var rect:CGRect = attrString!.boundingRectWithSize(CGSizeMake(300.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
    var requredSize:CGRect = rect
    return requredSize.height  //to include button's in your tableview
    
}




