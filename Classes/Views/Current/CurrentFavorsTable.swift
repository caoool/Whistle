//
//  CurrentFavorsTable.swift
//  Whistle
//
//  Created by Lu Cao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class CurrentFavorsTable: UITableViewController {
    
    var favors : NSMutableArray = NSMutableArray()
    var selectedIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadFavors", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadFavors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFavors(){
        let favorQuery : PFQuery = PFQuery(className: Constants.Favor.Name)
        favorQuery.limit = Constants.Favor.DefaultPaginationLimit
        favorQuery.whereKey(Constants.Favor.CreatedBy, equalTo: PFUser.currentUser()!)
        favorQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.favors.removeAllObjects()
                self.favors.addObjectsFromArray(objects!)
                println("favor count \(self.favors.count)")
                self.tableView.reloadData()
            } else {
                println("network error")
            }
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return favors.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CurrentFavorCell", forIndexPath: indexPath) as! CurrentFavorCell
//        cell.bindData(favors[indexPath.row] as! PFObject)
        let favor = favors[indexPath.row] as! PFObject
        let relation = favor.relationForKey(Constants.Favor.Takers)
        let query = relation.query()
        query!.countObjectsInBackgroundWithBlock { (count, error) -> Void in
            if error == nil {
                if count > 0 {
                    cell.statusButton.setImage(nil, forState: .Normal)
                    cell.statusButton.setTitle("33", forState: .Normal)
                    cell.statusButton.tag = indexPath.row
                    cell.statusButton.addTarget(self, action: "showTakers:", forControlEvents: .TouchUpInside)
                }
            }
        }
        cell.detailLabel.text = favor[Constants.Favor.Content] as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        performSegueWithIdentifier("CurrentFavorsTable_To_CurrentFavorVolunteersTable", sender: self)
    }
    
    func showTakers(sender: UIButton!) {
        var button : UIButton = sender
        self.selectedIndex = button.tag
        performSegueWithIdentifier("currentFavorsTableToAssistant", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "currentFavorsTableToAssistant" {
            var assistantsTable = segue.destinationViewController as! CurrentFavorAssistantsTable
            assistantsTable.favor = favors[selectedIndex] as? PFObject
        }
    }
}
