//
//  CurrentView.swift
//  Whistle
//
//  Created by Lu Cao on 6/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//


//----------------------------------------------------------------------------------------------------------
import UIKit
import Parse
//----------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------
class CurrentView: UITableViewController
//----------------------------------------------------------------------------------------------------------
{
    
    var favors : NSMutableArray = NSMutableArray()
    var selectedIndex : Int!
    var txt : [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam mattis tortor eget velit gravida hendrerit. Duis maximus est eget lectus congue, in consequat purus rutrum.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit." ,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = Constants.Color.TableBackground
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.title = "Current"
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadFavors", forControlEvents: UIControlEvents.ValueChanged)
        loadFavors()
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
        let assistCell = tableView.dequeueReusableCellWithIdentifier("CurrentAssistCell", forIndexPath: indexPath) as! CurrentAssistCell
        let favorCell = tableView.dequeueReusableCellWithIdentifier("CurrentFavorCell", forIndexPath: indexPath) as! CurrentFavorCell
        let favor = favors[indexPath.row] as! PFObject
        let user = PFUser.currentUser()
        
        if (favor[Constants.Favor.CreatedBy] as! PFUser) == user {
            favorCell.addText(txt[indexPath.row])
            return favorCell
        } else {
            assistCell.addText(txt[indexPath.row])
//            println(assistCell.frame)
//            let stack = createOptionsButton(CGPointMake(345, 88))
//            assistCell.addSubview(stack)
            return assistCell
        }
        //cell.detailLabel.text = favor[Constants.Favor.Content] as? String
        //var tapGesture = UITapGestureRecognizer(target: self, action: "goToOwnerProfile")
        //cell.ownerButton.addGestureRecognizer(tapGesture)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("CurrentFavorsTable_To_CurrentFavorVolunteersTable", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func goToOwnerProfile() {
//        performSegueWithIdentifier("CurrentFavorsTable_To_CurrentFavorVolunteersTable", sender: self)
    }
    
    func showTakers(sender: UIButton!) {
        var button : UIButton = sender
        self.selectedIndex = button.tag
        performSegueWithIdentifier("currentFavorsTableToAssistant", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "currentFavorsTableToAssistant" {
//            var assistantsTable = segue.destinationViewController as! CurrentFavorAssistantsTable
//            assistantsTable.favor = favors[selectedIndex] as? PFObject
//        }
    }

}
