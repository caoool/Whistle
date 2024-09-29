//
//  TabBarController.swift
//  Whistle
//
//  Created by Yetian Mao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class TabBarController : YALFoldingTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let item1 : YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "nearby_icon"),
            leftItemImage: UIImage(named: "edit_icon"),
            rightItemImage: nil)
        let item2 : YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "nearby_icon"),
            leftItemImage: UIImage(named: "edit_icon"),
            rightItemImage: UIImage(named: "edit_icon"))
        self.leftBarItems = [item1, item2]
        let item3 : YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "chats_icon"),
            leftItemImage: UIImage(named: "search_icon"),
            rightItemImage: UIImage(named: "new_chat_icon"))
        let item4 : YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "profile_icon"),
            leftItemImage: nil,
            rightItemImage: nil)
        self.rightBarItems = [item3, item4]
        self.centerButtonImage = UIImage(named: "plus_icon")
        self.selectedIndex = 3  
        
        //customize tabBarView
        self.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
        self.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        self.tabBarView.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0, blue: 149.0/255.0, alpha: 0)
        self.tabBarView.tabBarColor = UIColor(red: 72.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1)
        self.tabBarViewHeight = YALTabBarViewDefaultHeight
        self.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
        self.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets

    }
    
}
