//
//  ProfileFavorsTable.swift
//  Whistle
//
//  Created by Lu Cao on 6/28/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

//-------------------------------------------------------------------------------------------------------------------------------------------------
import UIKit
import Parse
//-------------------------------------------------------------------------------------------------------------------------------------------------

class ProfileFavorsTable: UITableViewController {
    
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
        favorQuery.whereKey(Constants.Favor.CreatedBy, equalTo: PFUser.currentUser()!)
        
        let assistQuery : PFQuery = PFQuery(className: Constants.Favor.Name)
        assistQuery.whereKey(Constants.Favor.AssistedBy, equalTo: PFUser.currentUser()!)
        
        let query : PFQuery = PFQuery.orQueryWithSubqueries([favorQuery, assistQuery])
        query.orderByDescending(Constants.Favor.UpdatedAt)
        query.findObjectsInBackgroundWithBlock {
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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favors.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileFavorCell", forIndexPath: indexPath) as! ProfileFavorCell
        
        let favor = favors[indexPath.row] as! PFObject
        if indexPath.row > 0 {
            let previousFavor = favors[indexPath.row - 1] as! PFObject
            cell.bindData(favor, previousFavor:  previousFavor)
        } else {
            cell.bindData(favor, previousFavor: nil)
        }
        
        return cell
    }
}