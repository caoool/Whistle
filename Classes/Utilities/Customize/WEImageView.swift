//
//  WEImageView.swift
//  Whistle
//
//  Created by Lu Cao on 7/13/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//


//----------------------------------------------------------------------------------------------------------
class WEImageView: UIImageView
//----------------------------------------------------------------------------------------------------------
{
    // MARK: - Init
    //----------------------------------------------------------------------------------------------------------
    required init(coder aDecoder: NSCoder)
    //----------------------------------------------------------------------------------------------------------
    {
        super.init(coder: aDecoder)
        
        userInteractionEnabled = true
        
        var gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        self.addGestureRecognizer(gesture)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func longPressed(sender: UILongPressGestureRecognizer)
    //----------------------------------------------------------------------------------------------------------
    {
        if sender.state == UIGestureRecognizerState.Began {
            let viewController = ProfileASController()
            let alert = SimpleAlert.Controller(view: viewController.view, style: .ActionSheet)
            showAlert(alert)
        }
    }
    
    
    // MARK: - Functions
    //----------------------------------------------------------------------------------------------------------
    func showAlert(alert: SimpleAlert.Controller)
    //----------------------------------------------------------------------------------------------------------
    {
        var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
        if topController != nil {
            while topController!.presentedViewController != nil {
                topController = topController!.presentedViewController
            }
        }
        
        alert.addAction(SimpleAlert.Action(title: "Cancel", style: .Cancel) { action in
            })
        alert.addAction(SimpleAlert.Action(title: "Chat", style: .Default) { action in
            })
        alert.addAction(SimpleAlert.Action(title: "Add Friend", style: .Default) { action in
            })
        
        topController?.presentViewController(alert, animated: true, completion: nil)
    }
}
