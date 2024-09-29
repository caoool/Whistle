//
//  TableMapViewController.swift
//  MapTable-Swift
//
//  Created by Gazolla on 18/07/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit
import MapKit

class TableMapViewController: UIViewController {
    
    var navHeight:CGFloat?
    var width:CGFloat?
    var halfHeight:CGFloat?
    var height:CGFloat?
    var firstPosition = true
    var tableController:VenuesTableView?
    var venues: Array<Venue> = [Venue]()
    var mapView:MapViewController?
    var tapFirstView:UIGestureRecognizer?
    var bigMap = false
    var detailVenue:VenueDetailViewController?
    
    var blockFinih: ((selectedAddress: Venue) -> ())!
    
    private var navigationBarItem: UINavigationItem!
    private var leftButton: UIBarButtonItem!
    private var rigthButton: UIBarButtonItem!
    
    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64))
        
        self.navigationBarItem = UINavigationItem()
        self.navigationBarItem.leftBarButtonItem = self.leftButton
        
        navigationBar.pushNavigationItem(self.navigationBarItem, animated: true)
        return navigationBar
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = Venue(aIdent:1, aName: "Whole Foods Market", aAddress: "20955 Stevens Creek Blvd", aCity: "Cupertino", aCategoryName: "Grocery Store", aLat: "37.323551", aLng: "-122.039653")
        let v2 = Venue(aIdent:2, aName: "Buffalo Wild Wings Grill & Bar", aAddress: "1620 Saratoga Ave", aCity: "San Jose", aCategoryName: "American Restaurant", aLat: "37.2979039", aLng: "-121.988112")
        let v3 = Venue(aIdent:3, aName: "Bierhaus", aAddress: "383 Castro St", aCity: "Mountain View", aCategoryName: "Gastropub", aLat: "37.3524382", aLng: "-121.9582429")
        let v4 = Venue(aIdent:4, aName: "Singularity University", aAddress: "Building 20 S. Akron Rd.", aCity: "Moffett Field", aCategoryName: "University", aLat: "37.3996033", aLng: "-122.0784488")
        let v5 = Venue(aIdent:5, aName: "Menlo Country Club", aAddress: "", aCity: "Woodside", aCategoryName: "Country Club", aLat: "37.4823348", aLng: "-122.2406688")
        let v6 = Venue(aIdent:6, aName: "Denny's", aAddress: "1015 Blossom Hill Rd", aCity: "San Jose", aCategoryName: "American Restaurant", aLat: "37.2384776", aLng: "-121.8007709")
        let v7 = Venue(aIdent:7, aName: "Refuge", aAddress: "963 Laurel St", aCity: "San Carlos", aCategoryName: "Restaurant", aLat: "37.5041949", aLng: "-122.2695079")
        
        var venuesArr : Array<Venue> = []
        venuesArr.append(v)
        venuesArr.append(v2)
        venuesArr.append(v3)
        venuesArr.append(v4)
        venuesArr.append(v5)
        venuesArr.append(v6)
        venuesArr.append(v7)
        
        navHeight = 0.0
        let frame = self.view.frame
        width = frame.size.width
        halfHeight = (frame.size.height - navHeight!)/2
        height = frame.size.height
        
        title = "Map & Table"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "mapViewTapped", name: "mapViewTapped", object: nil)
        
        mapView = MapViewController(frame: CGRectMake(0.0, navHeight!, width!, halfHeight!))
        
        tapFirstView = UITapGestureRecognizer(target: self, action: "mapViewTapped")
        mapView!.view.addGestureRecognizer(tapFirstView!)
        self.view.addSubview(self.mapView!.view)
        self.view.addSubview(self.navigationBar)
        
        tableController = VenuesTableView(frame: CGRectMake(0.0, halfHeight!, width!, halfHeight!))
        view.addSubview(tableController!.view)
        setVenueCollection(venuesArr)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "navigateToDetail:", name: "navigateToDetail", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"addressPicked:", name: "addressPicked", object: nil)
        
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        self.navigationBarItem.leftBarButtonItem = leftBarButtonItem
        
        // Do any additional setup after loading the view.
    }
    
    func close(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    convenience init(frame:CGRect){
        self.init(nibName: nil, bundle: nil)
        navHeight = 0.0
        width = frame.size.width
        halfHeight = (frame.size.height - navHeight!)/2
        height = frame.size.height
        
        title = "Map & Table"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "mapViewTapped", name: "mapViewTapped", object: nil)
        
        mapView = MapViewController(frame: CGRectMake(0.0, navHeight!, width!, halfHeight!))
      
        tapFirstView = UITapGestureRecognizer(target: self, action: "mapViewTapped")
        mapView!.view.addGestureRecognizer(tapFirstView!)
        self.view.addSubview(self.mapView!.view)
        
        tableController = VenuesTableView(frame: CGRectMake(0.0, halfHeight!, width!, halfHeight!))
        view.addSubview(tableController!.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "navigateToDetail:", name: "navigateToDetail", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"selectAnnotation:", name: "selectAnnotation", object: nil)
    }
    
    func addressPicked(notification :NSNotification){
        var selected : Venue = (notification.object as? Venue)!
        println(selected)
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.blockFinih(selectedAddress: selected)
        })
    }
    
    func mapViewTapped(){
        if (!bigMap){
            UIView.animateWithDuration(0.5,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 20.0,
                options: UIViewAnimationOptions.CurveEaseIn ,
                animations: {
                    self.mapView!.view.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.height!)
                    self.mapView!.map!.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.height!)
                    self.tableController!.view.center = CGPointMake(self.tableController!.view.center.x, self.tableController!.view.center.y+self.halfHeight!);
                },
                completion:{ (Bool)  in
                    let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: "reverse")
                    self.navigationBarItem.leftBarButtonItem = leftBarButtonItem
                    self.bigMap = true
                })
        }
    }
    
    func reverse(){
        if bigMap {
            UIView.animateWithDuration(0.5,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 20.0,
                options: UIViewAnimationOptions.CurveEaseIn ,
                animations: {
                    self.mapView!.view.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.halfHeight!)
                    self.mapView!.map!.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.halfHeight!)
                    self.tableController!.view.center = CGPointMake(self.tableController!.view.center.x, self.tableController!.view.center.y-self.halfHeight!);
                },
                completion:{ (Bool)  in
                    let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: "close")
                    self.navigationBarItem.leftBarButtonItem = leftBarButtonItem
                    self.bigMap = false
                    
                    if let selectedAnnotations = self.mapView!.map!.selectedAnnotations as? [MapPointAnnotation]{
                        for annotation in selectedAnnotations {
                            self.mapView!.map!.deselectAnnotation(annotation, animated: true)
                        }
                    }
                })
        }
        
    }

    func setVenueCollection(array: [Venue]!) {
         if (array != nil) {
            venues = array!
            tableController!.loadVenues(array!)
            mapView!.loadPointsWithArray(array!)
        }
    }
    
    func navigateToDetail(notification:NSNotification){
        
        if self.detailVenue == nil {
            self.detailVenue = VenueDetailViewController()
        }
        if let venue:Venue = notification.object as? Venue {
            self.detailVenue?.lblName?.text = venue.name
            self.detailVenue?.lblAddress?.text = venue.address
            self.detailVenue?.lblCity?.text = venue.city
        } else {
            println("no venue at TableMapController")
        }
        self.navigationController?.pushViewController(self.detailVenue!, animated: true)
        
    }
    
    class func displayMapViewController(#parentController: UIViewController, blockFinish: (selectedAddress: Venue)->(), blockCancel: ()->()) {
        let mapViewController = TableMapViewController()
        mapViewController.blockFinih = blockFinish
        mapViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        mapViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        parentController.presentViewController(mapViewController, animated: true, completion: nil)
    }
    
}
