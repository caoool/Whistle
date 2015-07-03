//
//  CurrentView.swift
//  Whistle
//
//  Created by Lu Cao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class CurrentView: UIViewController {
    
    @IBOutlet weak var myFavorsTableContainer: UIView!
    @IBOutlet weak var myAssistsTableContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Current"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectedTab(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            myFavorsTableContainer.hidden = false
            myAssistsTableContainer.hidden = true
        case 1:
            myFavorsTableContainer.hidden = true
            myAssistsTableContainer.hidden = false
        default:
            return
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
