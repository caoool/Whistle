
//
//  FavorMapView.swift
//  Whistle
//
//  Created by Lu Cao on 5/28/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import MapKit
import Parse

class AssistMapView: UIViewController, MKMapViewDelegate {
    
    private var favors : NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailView: UIView!
    
    // detail view
    @IBOutlet weak var portraitImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var interestView: UIView!
    @IBOutlet weak var progressingView: UIView!
    
    private var currentOrderIndex = 0
    
    private var annotations = [CustomPointAnnotation]()
    
    // for user location
    var manager: CLLocationManager!
    var myLocations: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadScene", name: "refresh", object: nil)
        loadFavors()
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
                NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: self)
            } else {
                println("network error")
            }
        }
        
    }
    
    func loadScene() {
        
        initMapCenter()
        
        if favors.count > 0 {
            addAnnotations()
            setDetailView()
            goToOrder(currentOrderIndex)
        }
        
        addSwipeGesturesToDetailView()
    }
    
    func reloadScene() {
        mapView.removeAnnotations(mapView.annotations)

        if favors.count > 0 {
            
            addAnnotations()
            setDetailView()
            goToOrder(currentOrderIndex)
        }
    }
    
    func setDetailView() {
        detailView.layer.borderWidth = 0.3
        detailView.layer.borderColor = UIColor.lightGrayColor().CGColor
        detailView.layer.cornerRadius = 12
        detailView.alpha = 0.9
        
        interestView.layer.borderWidth = 0.3
        interestView.layer.borderColor = UIColor.lightGrayColor().CGColor
        interestView.layer.cornerRadius = 12
        interestView.alpha = 0.9
        
        interestView.alpha = 0
        
        progressingView.layer.borderWidth = 0.3
        progressingView.layer.borderColor = UIColor.lightGrayColor().CGColor
        progressingView.layer.cornerRadius = 12
        progressingView.alpha = 0.9
        
        progressingView.alpha = 0
        
    }
    
    func initMapCenter() {
        
        mapView.delegate = self
        
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
            
            println(manager.location)
            let latitude = manager.location.coordinate.latitude
            let longitude = manager.location.coordinate.longitude
            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let regionRadius: CLLocationDistance = 10000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
    }
    
    func addAnnotations() {
        for favor in favors {
            let PFLocation = favor[Constants.Favor.Location] as! PFGeoPoint
            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: PFLocation.latitude, longitude: PFLocation.longitude)
            var annotation = CustomPointAnnotation()
            annotation.coordinate = location
            
            switch favor[Constants.Favor.Status] as! Int {
                case 0:
                    annotation.imageName = "map_regular_pin"
                case 1:
                    annotation.imageName = "map_interested_pin"
                case 2:
                    annotation.imageName = "map_processing_pin"
                default:
                break
            }
            
            mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
    }
    
    func goToOrder(i: Int) {
        setDetailViewContent(i)
        centerMapOnOrder(i)
    }
    
    func setDetailViewContent(i: Int) {
        let favor = favors[i] as! PFObject
        var user : PFUser = favor[Constants.Favor.User] as! PFUser
        var file = user[Constants.User.Portrait] as? PFFile
        file?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                self.portraitImage.image = UIImage(data: data!)!
            }
        })
        self.titleLabel.text = favor[Constants.Favor.Content] as? String
        self.priceLabel.text = favor[Constants.Favor.Price] as? String
        priceLabel.layer.backgroundColor = UIColorFromHex(0x000000, alpha: 0.02).CGColor
        switch favor[Constants.Favor.Status] as! Int {
        case 0:
            fadeOutView(interestView, 0.2)
            fadeOutView(progressingView, 0.2)
        case 1:
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.progressingView.alpha = 0.0
                }, completion: {
                    (finished: Bool) -> Void in
                    
                    // Fade in
                    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.interestView.alpha = 1.0
                        }, completion: nil)
            })
        case 2:
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.interestView.alpha = 0.0
                }, completion: {
                    (finished: Bool) -> Void in
                    
                    // Fade in
                    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        self.progressingView.alpha = 1.0
                        }, completion: nil)
            })
        default:
            break
        }
    }
    
    func centerMapOnOrder(i: Int) {
        let latitude = manager.location.coordinate.latitude
        let longitude = manager.location.coordinate.longitude
        let location: CLLocationCoordinate2D = annotations[i].coordinate
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func fadeAndChangeDetailViewContent(i: Int) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.detailView.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                
                self.goToOrder(i)
                
                // Fade in
                UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.detailView.alpha = 1.0
                    }, completion: nil)
        })
    }
    
    // MARK: - User Interaction
    func addSwipeGesturesToDetailView() {
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        detailView.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        detailView.addGestureRecognizer(swipeLeft)
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        detailView.addGestureRecognizer(swipeUp)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        detailView.addGestureRecognizer(swipeDown)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                if currentOrderIndex == 0 {
                    fadeAndChangeDetailViewContent(favors.count - 1)
                    currentOrderIndex = favors.count - 1
                } else {
                    fadeAndChangeDetailViewContent(--currentOrderIndex)
                }
                
            case UISwipeGestureRecognizerDirection.Left:
                if currentOrderIndex == favors.count - 1 {
                    fadeAndChangeDetailViewContent(0)
                    currentOrderIndex = 0
                } else {
                    fadeAndChangeDetailViewContent(++currentOrderIndex)
                }
                
            case UISwipeGestureRecognizerDirection.Up:
                println("up")
//                let favor = favors[currentOrderIndex] as! PFObject
//                let status = favor[Constants.Favor.Status] as! Int
//                
//                if status == 0 {
//                    fadeInView(interestView, 0.6)
//                    bounceView(interestView)
//                    testOrders[currentOrderIndex].status = "interested"
//                    mapView.removeAnnotation(annotations[currentOrderIndex])
//                    annotations[currentOrderIndex].imageName = "map_interested_pin"
//                    mapView.addAnnotation(annotations[currentOrderIndex])
//                } else if testOrders[currentOrderIndex].status == "interested" {
//                    fadeOutView(interestView, 0.6)
//                    bounceView(interestView)
//                    testOrders[currentOrderIndex].status = "regular"
//                    mapView.removeAnnotation(annotations[currentOrderIndex])
//                    annotations[currentOrderIndex].imageName = "map_regular_pin"
//                    mapView.addAnnotation(annotations[currentOrderIndex])
//                }
                
            case UISwipeGestureRecognizerDirection.Down:
                // TODO: - Something like refresh
                break
            default:
                break
            }
        }
    }
    
    // MARK: - Delegates
    
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
    @IBAction func goToDetailView(sender: UIButton) {
        performSegueWithIdentifier("AssistMapViewtoAssistDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AssistMapViewtoAssistDetail" {
            var svc = segue.destinationViewController as! AssistDetailView
            svc.favor = (favors[currentOrderIndex] as! PFObject)
        }
    }
    
    
    
}
