//
//  VenuesTableView.swift
//  MapTable-Swift
//
//  Created by Gazolla on 18/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class VenuesTableView: UITableViewController,UITableViewDelegate, UITableViewDataSource {
    
    var venues: [Venue] = []
    var rightButton:UIButton?
    let cellId = "cell"

    
     
    convenience init(frame:CGRect){
        self.init(style:.Plain)
        self.title = "Plain Table"
        self.view.frame = frame
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
    }
    
    func loadVenues(array: [Venue]) {
        self.venues = array
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.venues.count as Int
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath) as! UITableViewCell
        
        var venue = self.venues[indexPath.row] as Venue
        cell.textLabel!.text = venue.name
        println("venue category: \(venue.categoryName)")
    //    cell.detailTextLabel!.text = venue.categoryName
        return cell
    }
    
   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell?
        println(cell?.textLabel?.text)
        let venue:Venue = self.venues[indexPath.row] as Venue
        NSNotificationCenter.defaultCenter().postNotificationName("selectAnnotation", object: venue)
        NSNotificationCenter.defaultCenter().postNotificationName("addressPicked", object: venue)
    }
}
