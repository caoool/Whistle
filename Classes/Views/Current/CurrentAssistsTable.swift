//
//  CurrentAssistsTable.swift
//  Whistle
//
//  Created by Lu Cao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class CurrentAssistsTable: UITableViewController {
    
    var favors : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavors()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadFavors", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFavors(){
        let favorQuery : PFQuery = PFQuery(className: Constants.Favor.Name)
        favorQuery.limit = Constants.Favor.DefaultPaginationLimit
        favorQuery.whereKey(Constants.Favor.Takers, equalTo: PFUser.currentUser()!)
        favorQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.favors.removeAllObjects()
                self.favors.addObjectsFromArray(objects!)
                println("assist count \(self.favors.count)")
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CurrentAssistCell", forIndexPath: indexPath) as! CurrentAssistCell
        let favor = favors[indexPath.row] as! PFObject
        cell.detailLabel.text = favor[Constants.Favor.Content] as? String
        var tapGesture = UITapGestureRecognizer(target: self, action: "goToOwnerProfile")
        cell.ownerButton.addGestureRecognizer(tapGesture)
        
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        performSegueWithIdentifier("CurrentFavorsTable_To_CurrentFavorVolunteersTable", sender: self)
    }
    
    func goToOwnerProfile() {
//        performSegueWithIdentifier("CurrentFavorsTable_To_CurrentFavorVolunteersTable", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
