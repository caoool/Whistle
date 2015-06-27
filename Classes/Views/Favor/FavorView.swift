//
//  FavorView.swift
//  Whistle
//
//  Created by Lu Cao on 6/24/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import MapKit
import Parse

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class FavorView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: - Testing data
    var favors : NSMutableArray = NSMutableArray()
    private var favorIndex: Int = 0 {
        didSet {
            if favorIndex > favors.count - 1 {
                favorIndex = 0
            }
            if favorIndex < 0 {
                favorIndex = favors.count - 1
            }
        }
    }

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var foldButton: UIButton!
    
    // MARK: - Variables
    var manager: CLLocationManager!
    private var isCenteredOnUserLocation = false
    private var annotations = [CustomPointAnnotation]()
    private var tableView: FavorDetailTable?
    
    private var isFolded = false
    private var detailViewOriginalFrame: CGRect?
    private var imageScrollerOriginalFrame: CGRect?
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadScene", name: "refresh", object: nil)
        configMapView()
        configContainerView()
    }
    
    override func viewDidLayoutSubviews() {
        configDefaults()
        configShapes()
    }
    
    func configShapes() {
        mapView.roundCorners(.TopLeft | .TopRight, radius: Constants.Radius.CornerBig)
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
            } else {
                println("network error")
            }
        }
    }
    
    // MARK: - Map
    func configMapView() {
        mapView.delegate = self
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
        
        addAnnotations()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if !isCenteredOnUserLocation {
            centerMapOnUser()
            isCenteredOnUserLocation = !isCenteredOnUserLocation
        }
    }
    
    func centerMapOnUser() {
        let latitude = manager.location.coordinate.latitude
        let longitude = manager.location.coordinate.longitude
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnFavor() {
        let location: CLLocationCoordinate2D = annotations[favorIndex].coordinate
        let regionRadius: CLLocationDistance = 100
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
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
    
    // MARK: - Detail table
    func configContainerView() {
        detailView.userInteractionEnabled = true
        addSwipeGesturesToDetailView()
        
        tableView = childViewControllers.last as? FavorDetailTable
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "fullScreenImageScroller")
        tableView!.imageScrollView.addGestureRecognizer(tapGesture)
    }
    
    func configDefaults() {
        detailViewOriginalFrame = detailView.frame
    }
    
    func fullScreenImageScroller() {
        var fullScreenScroller = UIScrollView(frame: view.frame)
        var imageView = UIImageView(frame: fullScreenScroller.frame)
        imageView.image = tableView?.images[tableView!.pageControl.currentPage]
        fullScreenScroller.addSubview(imageView)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "dismissFullScreenImageScroller:")
        fullScreenScroller.addGestureRecognizer(tapGesture)
        view.addSubview(fullScreenScroller)
    }
    
    func dismissFullScreenImageScroller(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }

    // MARK: - IBActions
    @IBAction func centerMapOnUserButtonTapped(sender: UIButton) {
        centerMapOnUser()
    }
    
    @IBAction func foldButtonPressed(sender: AnyObject) {
        if !isFolded {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                var yDif = self.detailView.layer.frame.origin.y - self.foldButton.layer.frame.origin.y
                self.detailView.frame = self.view.frame
                self.foldButton.layer.frame.origin.y = self.detailView.layer.frame.origin.y - yDif
                }, completion: {
                    (finished: Bool) -> Void in
                    self.isFolded = !self.isFolded
            })
        } else {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                var yDif = self.detailView.layer.frame.origin.y - self.foldButton.layer.frame.origin.y
                self.detailView.frame = self.detailViewOriginalFrame!
                self.foldButton.layer.frame.origin.y = self.detailView.layer.frame.origin.y - yDif
                }, completion: {
                    (finished: Bool) -> Void in
                    self.isFolded = !self.isFolded
            })
        }
        
    }
    
    // MARK: - User interactions
    func addSwipeGesturesToDetailView() {
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        detailView.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        detailView.addGestureRecognizer(swipeLeft)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                favorIndex++
                centerMapOnFavor()
            case UISwipeGestureRecognizerDirection.Left:
                favorIndex--
                centerMapOnFavor()
            default:
                break
            }
        }
    }


}











