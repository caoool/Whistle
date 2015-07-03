//
//  FavorListTable.swift
//  Whistle
//
//  Created by Lu Cao on 7/2/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

//----------------------------------------------------------------------------------------------------------
import UIKit
//----------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------
class FavorListTable: UITableViewController
//----------------------------------------------------------------------------------------------------------
{

    // MARK: - Initializations
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    //----------------------------------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
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
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
    }

    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    //----------------------------------------------------------------------------------------------------------
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavorListCell", forIndexPath: indexPath) as! FavorListCell

        return cell
    }

    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //----------------------------------------------------------------------------------------------------------
    {
        return 60
    }

}
