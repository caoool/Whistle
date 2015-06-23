//
//  DiscoverView.swift
//  Whistle
//
//  Created by Lu Cao on 5/4/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class DiscoverView: UIViewController {
    
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    private var arrangeBarButton: UIBarButtonItem!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewList: UIView!
    
    private var assistMapView: AssistMapView?
    private var assistListView: AssistListView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrangeBarButton = UIBarButtonItem(title: "Arrange", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        arrangeBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.setRightBarButtonItems([rightBarItem,arrangeBarButton], animated: true)
        
        arrangeBarButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        containerView.hidden = false
        containerViewList.hidden = true
    }
    
    // MARK: - Tags
    
    @IBAction func showTags(sender: UIBarButtonItem) {
        
        let item1 = Tag(issSelected: true, isLocked: true, textContent: "Hello1")
        let item2 = Tag(issSelected: true, isLocked: true, textContent: "Hello2")
        let item3 = Tag(issSelected: false, isLocked: true, textContent: "Hello3")
        let item4 = Tag(issSelected: false, isLocked: true, textContent: "Hello4")
        let item5 = Tag(issSelected: true, isLocked: true, textContent: "Hello5")
        let tags = [item1, item2, item3, item4, item5]
        
        RRTagController.displayTagController(parentController: self, tags: tags, blockFinish: { (selectedTags, unSelectedTags) -> () in
            // ok
            for tag in selectedTags {
                // TODO: save selectedTags
                self.assistMapView!.reloadScene()
                
            }
            }) { () -> () in
                // cancelled
        }
    }
    
    /**
    Swap container view to show list or map
    */
    @IBAction func swapContainerView(sender: UIBarButtonItem) {
        if containerView.hidden == true {
            containerView.hidden = false
            containerViewList.hidden = true
            sender.title = "List"
            arrangeBarButton.enabled = false
        } else {
            containerViewList.hidden = false
            containerView.hidden = true
            sender.title = "Map"
            arrangeBarButton.enabled = true
        }
    }
    
    
    // MARK: - Navigations
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAssistMapView" {
            assistMapView = segue.destinationViewController as? AssistMapView
        } else if segue.identifier == "toAssistListView" {
            assistListView = segue.destinationViewController as? AssistListView
        }
    }
    
    
}

