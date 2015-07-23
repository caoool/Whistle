//
//  ProfileFavorsTable.swift
//  Whistle
//
//  Created by Lu Cao on 6/28/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

//----------------------------------------------------------------------------------------------------------
import UIKit
import Parse
//----------------------------------------------------------------------------------------------------------



//----------------------------------------------------------------------------------------------------------
class ProfileFavorsTable: UITableViewController
//----------------------------------------------------------------------------------------------------------
{
    // MARK: - Variables
    //----------------------------------------------------------------------------------------------------------
    var favors : NSMutableArray                                 = NSMutableArray()
    //----------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Initializations
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    //----------------------------------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        configLooks()
        
        loadFavors()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadFavors", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    // MARK: - Functions
    //----------------------------------------------------------------------------------------------------------
    func configLooks()
    //----------------------------------------------------------------------------------------------------------
    {
        tableView.backgroundColor                               = Constants.Color.TableBackground
        tableView.contentInset                                  = UIEdgeInsetsMake(80, 0, YALTabBarViewDefaultHeight + 30, 0)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func loadFavors()
    //----------------------------------------------------------------------------------------------------------
    {
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
    
    // MARK: - Delegates
    //----------------------------------------------------------------------------------------------------------
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    //----------------------------------------------------------------------------------------------------------
    {
        return 1
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    //----------------------------------------------------------------------------------------------------------
    {
        return favors.count+2
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    //----------------------------------------------------------------------------------------------------------
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileFavorCell", forIndexPath: indexPath) as! ProfileFavorCell
        
        if indexPath.row == 0 {
            cell.dotBottom.hidden = false
            cell.portrait.hidden = true
            cell.line.hidden = true
        }
        
        if indexPath.row == favors.count + 1 {
            cell.dotBottom.hidden = false
            cell.portrait.hidden = true
            cell.line.hidden = true
        }
        
        if indexPath.row > 0 && indexPath.row < favors.count + 1{
            let favor = favors[indexPath.row-1] as! PFObject
            if indexPath.row > 1 {
                let prevFavor = favors[indexPath.row-2] as! PFObject
                cell.bindData(favor, previousFavor: prevFavor)
            } else if indexPath.row != favors.count+1 {
                cell.bindData(favor, previousFavor: nil)
            }
        }
        
        
//        if indexPath.row > 1 {
//            let prevFavor = favors[indexPath.row-1] as! PFObject
//            cell.bindData(favor, previousFavor: prevFavor)
//        } else if indexPath != 0 {
//            
//        }

        return cell
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //----------------------------------------------------------------------------------------------------------
    {
        if indexPath.row == 0 {
            return 23
        } else if indexPath.row == favors.count + 1 {
            return 30
        } else {
            return 100
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}









