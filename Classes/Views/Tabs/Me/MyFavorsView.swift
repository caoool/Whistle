//
//  MyOrdersRequestsTVC.swift
//  Arrived
//
//  Created by Lu Cao on 5/31/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class MyFavorsView: UITableViewController {
    
    private var favors : NSMutableArray = NSMutableArray()
    private var selectedFavor : PFObject?
    private var selectedIndex : Int?
    
    var willAnimateRipple = true {
        didSet {
            if willAnimateRipple {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide seperator below each cell
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadFavors:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        loadFavors()
        
        navigationController?.navigationBar.topItem!.title = ""
        
    }
    
    func loadFavors(){
        
        let favorQuery : PFQuery = PFQuery(className: Constants.Favor.Name)
        favorQuery.limit = Constants.Favor.DefaultPaginationLimit
        favorQuery.includeKey(Constants.Favor.Tag)
        favorQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.favors.removeAllObjects()
                self.favors.addObjectsFromArray(objects!)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("FavorCell", forIndexPath: indexPath) as! FavorCell
        cell.bindData(favors[indexPath.row] as! PFObject)
        cell.takersButton.tag = indexPath.row
        cell.takersButton.addTarget(self, action: "showTakers:", forControlEvents: .TouchUpInside)
        cell.selectionStyle = .None
        cell.alpha = 0.9
        return cell
    }
    
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func ripple(cell: FavorCell) {
        
        var option = Ripple.option()
        //configure
        option.borderWidth = CGFloat(1)
        option.radius = cell.takersButton.layer.frame.height/2 * 1.2
        option.duration = CFTimeInterval(1.5)
        option.borderColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.3)
        option.fillColor = UIColor.clearColor()
        option.scale = CGFloat(1.1)
        
        if willAnimateRipple {
            Ripple.run(cell.takersButton, locationInView: cell.takersButton.center, option: option) {}
            delay(1) {
                self.ripple(cell)
            }
            
        }
    }
    
    func showProgress() {
        performSegueWithIdentifier("RequestShowProgress", sender: self)
    }
    
    func showTakers(sender: UIButton!) {
        var button : UIButton = sender
        self.selectedIndex = button.tag
        performSegueWithIdentifier("ShowAssistants", sender: self)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavorCell", forIndexPath: indexPath) as! FavorCell
        
        selectedFavor = favors[indexPath.row] as? PFObject
        performSegueWithIdentifier("ShowFavorDetail", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowFavorDetail" {
            var svc = segue.destinationViewController as! AssistDetailView
            svc.favor = selectedFavor
        }
        if segue.identifier == "ShowAssistants" {
            var svc = segue.destinationViewController as! MyFavorsAssistantsView
            svc.favor = favors[selectedIndex!] as? PFObject
        }
        
    }
    
}
