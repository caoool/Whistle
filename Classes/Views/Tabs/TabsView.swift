//
//  TabsView.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class TabsView: UITabBarController, UITabBarDelegate {
    
    private var buttonImage: UIImage? = UIImage(named: "tab_center")
    private var buttonHightLightImage: UIImage?
    private var button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    private var centerButtonSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCenterButton()
    }
    
    /**
    Add center button
    */
    func addCenterButton() {
        button.frame = CGRectMake(0.0, 0.0, self.tabBar.frame.size.height-5, self.tabBar.frame.size.height-5)
        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        button.center = self.tabBar.center
        button.addTarget(self, action: "pressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func pressed(sender: UIButton!) {
        centerButtonSelected = true
        if centerButtonSelected {
            performSegueWithIdentifier("CreateNewFavor", sender: self)
        }
    }
    
    
    
}
