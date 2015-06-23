//
//  UserLocationsTVC.swift
//  Whistle
//
//  Created by Lu Cao on 5/3/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class MyAddressView: UITableViewController, MKMapViewDelegate, UITableViewDelegate {
    
    private struct address {
        var street: String?
        var city: String?
        var state: String?
        var country: String?
        var post: Int?
        var latitude: Double?
        var longitude: Double?
    }
    
    private var address1 = address(street: "Apple Inc., Infinite Loop", city: "Cupertino", state: "CA", country: "USA", post: 95014, latitude: 37.3320951, longitude: -122.0307425)
    private var address2 = address(street: "14055 Chester Ave", city: "Saratoga", state: "CA", country: "USA", post: 95070, latitude: 37.264462, longitude: -122.001732)
    private var address3 = address(street: "14055 Chester Ave", city: "Saratoga", state: "CA", country: "USA", post: 95070, latitude: 37.264462, longitude: -122.001732)
    
    private var addresses = [address]()
    
    private var checkedIndexPath : NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addresses = [address1, address2, address3]
        
        // hide seperator below each cell
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // set top margin of table view
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        title = "My Addresses"
        navigationController?.navigationBar.topItem!.title = ""
        tableView.reloadData()
    }
    

    
    // MARK: - TableView Delegates
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! AddressCell
        
        
        
        var cellAddress = addresses[indexPath.row]
        cell.streetLabel.text = cellAddress.street
        cell.cityLabel.text = cellAddress.city
        cell.stateLabel.text = cellAddress.state
        cell.countryLabel.text = cellAddress.country
        cell.postLabel.text = "\(cellAddress.post!)"
        
        cell.map.delegate = self
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: cellAddress.latitude!, longitude: cellAddress.longitude!)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        cell.map.setRegion(coordinateRegion, animated: true)
        
        /* display annotation in middle
        var annotation = CustomPointAnnotation()
        annotation.coordinate = location
        annotation.imageName = "map pin.png"
        cell.map.addAnnotation(annotation)
        */
        cell.map.showsUserLocation = true
        
        /* encontered a problem where only the last map got updated
        var locationManager = LocationManager.sharedInstance
        let addressString = "\(cellAddress.street), \(cellAddress.city), \(cellAddress.state) \(cellAddress.post), \(cellAddress.country)"
        locationManager.geocodeAddressString(address: addressString) {
        (geocodeInfo,placemark,error) -> Void in
        
        if(error != nil) {
        println(error)
        } else {
        print(geocodeInfo!)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double((geocodeInfo!["latitude"]! as! NSString).doubleValue), longitude: Double((geocodeInfo!["longitude"]! as! NSString).doubleValue))
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        cell.map.setRegion(coordinateRegion, animated: true)
        }
        }
        */
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (self.checkedIndexPath != nil) {
            if let var cell = tableView.cellForRowAtIndexPath(self.checkedIndexPath!) as? AddressCell {
                fadeOutView(cell.defaultIndicator, 0.35)
            }
            
        }
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! AddressCell
        fadeInView(cell.defaultIndicator, 0.35)
        
        self.checkedIndexPath = indexPath
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // Delete the row from the data source
            addresses.removeAtIndex(indexPath.row)
            
            // also need to delete from the server)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
    }
    
    // Customize annotation appearance
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }
        else {
            anView.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    // MARK: - Navigation
    
    
    @IBAction func dismissScene(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
