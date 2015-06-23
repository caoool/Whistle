//
//  MyFavorsAssistantsView.swift
//  Whistle
//
//  Created by Lu Cao on 5/31/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class MyFavorsAssistantsView: UITableViewController {

    struct testData {
        var name: String?
        var line: String?
        var likes: Int?
        var dislikes: Int?
        var jobsDone: Int?
    }
    
    var testDataArray = [testData]()
    var favor : PFObject?
    var users : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setUpTestData()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadUsers:", forControlEvents: UIControlEvents.ValueChanged)

        initScene()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadUsers()
    }
    
    func setUpTestData() {
        var data1 = testData(name: "Luu", line: "We all love you", likes: 300, dislikes: 0, jobsDone: 500)
        var data2 = testData(name: "Fucker", line: "We all hate you", likes: 0, dislikes: 300, jobsDone: 0)
        var data3 = testData(name: "Mr Ordinary", line: "We all ignore you", likes: 0, dislikes: 0, jobsDone: 0)
        testDataArray = [data1, data2, data3]
    }

    func initScene() {
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // add blur background
//        var bgBlurView = UIImageView()
//        bgBlurView.image = UIImage(named: "my portrait")
//        bgBlurView.frame = CGRectMake(-(tableView.frame.height - tableView.frame.width)/2, 0, tableView.frame.height, tableView.frame.height)
//        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
//        var blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = bgBlurView.bounds
//        bgBlurView.addSubview(blurView)
//        self.tableView.backgroundView = bgBlurView
        
        // hide seperator below each cell
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

    }
    
    func loadUsers(){
        
        let relation = favor!.relationForKey(Constants.Favor.Interested)
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
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return users.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyFavorsAssistantCell", forIndexPath: indexPath) as! MyFavorsAssistantCell

        cell.bindData(users[indexPath.row] as! PFUser)
//        cell.portrait.image = UIImage(named: "my portrait")
//        cell.nickname.text = testDataArray[indexPath.row].name
//        cell.status.text = testDataArray[indexPath.row].line
//        cell.likes.text = "\(testDataArray[indexPath.row].likes!)"
//        cell.dislikes.text = "\(testDataArray[indexPath.row].dislikes!)"
//        cell.jobsDone.text = "\(testDataArray[indexPath.row].jobsDone!)"

        return cell
    }

}
