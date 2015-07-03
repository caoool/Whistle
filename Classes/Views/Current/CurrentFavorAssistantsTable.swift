//
//  CurrentFavorAssistantsTable.swift
//  Whistle
//
//  Created by Lu Cao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class CurrentFavorAssistantsTable: UITableViewController {
    
    var favor : PFObject?
    private var users : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadUsers", forControlEvents: UIControlEvents.ValueChanged)
        loadUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUsers(){
        
        let relation = favor!.relationForKey(Constants.Favor.Takers)
        let query = relation.query()
        query!.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.users.removeAllObjects()
                self.users.addObjectsFromArray(objects!)
                self.tableView.reloadData()
            } else {
                println("network error")
            }
            self.refreshControl?.endRefreshing()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CurrentFavorAssistantCell", forIndexPath: indexPath) as! CurrentFavorAssistantCell
        cell.bindData(users[indexPath.row] as! PFUser)
        cell.favor = favor!
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}
