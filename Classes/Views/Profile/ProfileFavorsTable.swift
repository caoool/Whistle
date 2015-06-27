//
//  ProfileFavorsTable.swift
//  Whistle
//
//  Created by Lu Cao on 6/28/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class ProfileFavorsTable: UITableViewController {
    
    struct Favor {
        private var time: NSDate?
        private var portrait: UIImage?
        private var detail: String?
        private var isMyFavor: Bool?
    }
    
    private var favors = [Favor]()
    
    func generateTestData() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM"
        var favor = Favor(time: formatter.dateFromString("12/06"), portrait: UIImage(named: "default_user_photo"), detail: "Bla bla bla bla bla bla ... bla bla bla bla bla bla bla .... bla", isMyFavor: true)
        favors.append(favor)
        favor = Favor(time: formatter.dateFromString("12/06"), portrait: UIImage(named: "default_user_photo"), detail: "Bla bla bla bla bla bla ... bla bla bla bla bla bla bla .... bla", isMyFavor: false)
        favors.append(favor)
        favors.append(favor)
        favor = Favor(time: formatter.dateFromString("10/06"), portrait: UIImage(named: "default_user_photo"), detail: "Bla bla bla bla bla bla ... bla bla bla bla bla bla bla .... bla", isMyFavor: true)
        favors.append(favor)
        favors.append(favor)
        favors.append(favor)
        favors.append(favor)
        favor = Favor(time: formatter.dateFromString("01/06"), portrait: UIImage(named: "default_user_photo"), detail: "Bla bla bla bla bla bla ... bla bla bla bla bla bla bla .... bla", isMyFavor: false)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTestData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileFavorCell", forIndexPath: indexPath) as! ProfileFavorCell

        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM"
        cell.dateLabel.text = formatter.stringFromDate(favors[indexPath.row].time!)
        if indexPath.row > 0 {
            if cell.dateLabel.text == formatter.stringFromDate(favors[indexPath.row-1].time!) {
                cell.dateLabel.hidden = true
            }
        }
        if favors[indexPath.row].isMyFavor! {
            cell.portrait1.hidden = true
            cell.addConstraint(cell.leftMoreCons)
            cell.portrait2.image = favors[indexPath.row].portrait
        } else {
            cell.portrait2.hidden = true
            cell.addConstraint(cell.rightMoreCons)
            cell.portrait1.image = favors[indexPath.row].portrait
        }
        cell.detailLabel.text = favors[indexPath.row].detail!

        return cell
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
