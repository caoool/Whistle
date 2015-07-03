//
//  FavorView.swift
//  Whistle
//
//  Created by Lu Cao on 6/24/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//


//----------------------------------------------------------------------------------------------------------
import UIKit
import MapKit
import Parse
//----------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------
class CustomPointAnnotation: MKPointAnnotation
//----------------------------------------------------------------------------------------------------------
{
    var imageName: String!
}

//----------------------------------------------------------------------------------------------------------
class FavorView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, YALTabBarInteracting
//----------------------------------------------------------------------------------------------------------
{
    // MARK: - Favors Data
    //----------------------------------------------------------------------------------------------------------
    var favors : NSMutableArray = NSMutableArray()
    private var index: Int = 0 {
        didSet {
            if index > favors.count - 1 {
                index = 0
            }
            if index < 0 {
                index = favors.count - 1
            }
        }
    }

    
    // MARK: - IBOutlets
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var mapView                          : MKMapView!
    @IBOutlet weak var detailView                       : UIView!
    @IBOutlet weak var foldUpButton                     : UIButton!
    @IBOutlet weak var foldUpFunctionButton             : UIButton!
    @IBOutlet weak var foldDownButton                   : UIButton!
    @IBOutlet weak var foldDownFunctionButton           : UIButton!
    @IBOutlet weak var centerOnUserButton               : UIButton!
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var searchButton                     : UIBarButtonItem!
    //----------------------------------------------------------------------------------------------------------
    
    // MARK: - Variables
    //----------------------------------------------------------------------------------------------------------
    private var timer                                   : NSTimer?
    private var interested: Bool                        = false
    private var manager                                 : CLLocationManager!
    private var isCenteredOnUserLocation                = false
    private var annotations                             = [CustomPointAnnotation]()
    private var tableView                               : FavorDetailTable?
    //----------------------------------------------------------------------------------------------------------
    private var displayerMode: Int = 1                  // 0: all map; 1: Splitted; 2: all table
    private var mapViewOriginalFrame                    : CGRect?
    private var detailViewOriginalFrame                 : CGRect?
    private var foldUpButtonOriginalFrame               : CGRect?
    private var foldDownButtonOriginalFrame             : CGRect?
    private var centerOnUserButtonOriginalFrame         : CGRect?
    private var imageScrollerOriginalFrame              : CGRect?
    //----------------------------------------------------------------------------------------------------------
    private var isAnimatingBreathing: Bool              = false
    //----------------------------------------------------------------------------------------------------------
    
    // MARK: - Initialization
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    //----------------------------------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadScene", name: "loadFavors", object: nil)
        loadFavors()
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func viewWillAppear(animated: Bool)
    //----------------------------------------------------------------------------------------------------------
    {
        super.viewWillAppear(true)
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "buttonBreathEffect", userInfo: nil, repeats: true)
        changeDisplayMode(0)
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLayoutSubviews()
    //----------------------------------------------------------------------------------------------------------
    {
        configShapes()
        changeDisplayMode(0)
    }
    
    
    // MARK: - IBActions
    //----------------------------------------------------------------------------------------------------------
    @IBAction func centerMapOnUserButtonTapped(sender: UIButton)
    //----------------------------------------------------------------------------------------------------------
    {
        centerMapOnUser()
    }
    
    //----------------------------------------------------------------------------------------------------------
    @IBAction func foldUpButtonTapped(sender: UIButton)
    //----------------------------------------------------------------------------------------------------------
    {
        switch displayerMode {
        case 0:
            changeDisplayMode(1)
        case 1:
            changeDisplayMode(2)
        case 2:
            return
        default:
            return
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    @IBAction func foldDownButtonTapped(sender: AnyObject)
    //----------------------------------------------------------------------------------------------------------
    {
        switch displayerMode {
        case 0:
            return
        case 1:
            changeDisplayMode(0)
        case 2:
            changeDisplayMode(1)
        default:
            return
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    @IBAction func conditionButtonTapped(sender: UIBarButtonItem)
    //----------------------------------------------------------------------------------------------------------
    {
        
    }
    
    //----------------------------------------------------------------------------------------------------------
    @IBAction func refreshButtonTapped(sender: UIBarButtonItem)
    //----------------------------------------------------------------------------------------------------------
    {
        
    }

    
    // MARK: - User interactions
    //----------------------------------------------------------------------------------------------------------
    func addSwipeGesturesToDetailView()
    //----------------------------------------------------------------------------------------------------------
    {
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        detailView.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        detailView.addGestureRecognizer(swipeLeft)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func respondToSwipeGesture(gesture: UIGestureRecognizer)
    //----------------------------------------------------------------------------------------------------------
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                index++
                tableView!.bindData(favors[index] as! PFObject)
                centerMapOnFavor()
            case UISwipeGestureRecognizerDirection.Left:
                index--
                tableView!.bindData(favors[index] as! PFObject)
                centerMapOnFavor()
            default:
                break
            }
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    func extraLeftItemDidPressed()
    //----------------------------------------------------------------------------------------------------------
    {
        performSegueWithIdentifier("mainToNew", sender: self)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func extraRightItemDidPressed() {
    //----------------------------------------------------------------------------------------------------------
        if !interested {
            interested = !interested
            
            let favor = favors[index] as! PFObject
            let relation = favor.relationForKey(Constants.Favor.Takers)
            relation.addObject(PFUser.currentUser()!)
            favor.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    println("send interest success")
                } else {
                    println("failed")
                }
            })
        } else {
            interested = !interested
            let favor = favors[index] as! PFObject
            let relation = favor.relationForKey(Constants.Favor.Takers)
            relation.removeObject(PFUser.currentUser()!)
            favor.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    println("send not interest success")
                } else {
                    println("failed")
                }
            })
        }
    }
    
    
    // MARK: - Functions
    //----------------------------------------------------------------------------------------------------------
    func loadFavors()
    //----------------------------------------------------------------------------------------------------------
    {
        let favorQuery : PFQuery = PFQuery(className: Constants.Favor.Name)
        favorQuery.limit = Constants.Favor.DefaultPaginationLimit
        favorQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.favors.removeAllObjects()
                self.favors.addObjectsFromArray(objects!)
                NSNotificationCenter.defaultCenter().postNotificationName("loadFavors", object: self)
            } else {
                println("network error")
            }
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    func loadScene()
    //----------------------------------------------------------------------------------------------------------
    {
        configNavBarButton()
        configMapView()
        configContainerView()
        configLooks()
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configNavBarButton()
    //----------------------------------------------------------------------------------------------------------
    {
        var rightSearchBarButtonItem: UIBarButtonItem = searchButton
        var rightListBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "List", style: UIBarButtonItemStyle.Plain, target: self, action: "searchTapped:")
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem,rightListBarButtonItem], animated: true)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func searchTapped(sender:UIButton)
    //----------------------------------------------------------------------------------------------------------
    {
        performSegueWithIdentifier("FavorView_To_FavorListTable", sender: self)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configLooks()
    //----------------------------------------------------------------------------------------------------------
    {

    }
    
    //----------------------------------------------------------------------------------------------------------
    func configShapes()
    //----------------------------------------------------------------------------------------------------------
    {
        
    }
    
    //----------------------------------------------------------------------------------------------------------
    func changeDisplayMode(mode: Int)
    //----------------------------------------------------------------------------------------------------------
    {
        var tabBarHeight = YALTabBarViewDefaultHeight
        var naviBarHeight = navigationController?.navigationBar.frame.height
        
        switch displayerMode {
        case 0:
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.mapView.frame                                  = self.mapViewOriginalFrame!
                self.foldUpButton.frame                             = self.foldUpButtonOriginalFrame!
                self.foldUpFunctionButton.frame                     = self.foldUpButtonOriginalFrame!
                self.centerOnUserButton.frame                       = self.centerOnUserButtonOriginalFrame!
                self.detailView.alpha                               = 1
                self.foldDownButton.hidden                          = false
                self.foldDownFunctionButton.hidden                  = false
                }, completion: {
                    (finished: Bool) -> Void in
                    self.displayerMode                              = 1
            })
        case 1:
            if mode == 0 {
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.mapViewOriginalFrame                       = self.mapView.frame
                    self.foldUpButtonOriginalFrame                  = self.foldUpButton.frame
                    self.centerOnUserButtonOriginalFrame            = self.centerOnUserButton.frame
                    self.detailView.alpha                           = 0
                    self.foldUpButton.hidden                        = false
                    self.foldUpFunctionButton.hidden                = false
                    self.foldDownButton.hidden                      = true
                    self.foldDownFunctionButton.hidden              = true
                    self.mapView.frame                              = self.view.frame
                    self.foldUpButton.layer.frame.origin.y          = self.view.frame.origin.y + self.view.frame.size.height - tabBarHeight - 30
                    self.foldUpFunctionButton.layer.frame.origin.y  = self.view.frame.origin.y + self.view.frame.size.height - tabBarHeight - 30
                    self.centerOnUserButton.layer.frame.origin.y    = self.view.frame.origin.y + self.view.frame.size.height - tabBarHeight - 30
                    }, completion: {
                        (finished: Bool) -> Void in
                        self.displayerMode = 0
                })
            }
            if mode == 2 {
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.detailViewOriginalFrame                    = self.detailView.frame
                    self.foldDownButtonOriginalFrame                = self.foldDownButton.frame
                    self.detailView.alpha                           = 1
                    self.foldUpButton.hidden                        = true
                    self.foldUpFunctionButton.hidden                = true
                    self.foldDownButton.hidden                      = false
                    self.foldDownFunctionButton.hidden              = false
                    self.detailView.frame                           = CGRectMake(0, naviBarHeight!, self.view.frame.width, self.view.frame.height - naviBarHeight!)
                    self.foldDownButton.layer.frame.origin.y        = self.view.frame.origin.y + naviBarHeight! + 30
                    self.foldDownFunctionButton.layer.frame.origin.y = self.view.frame.origin.y + naviBarHeight! + 30
                    }, completion: {
                        (finished: Bool) -> Void in
                        self.displayerMode                          = 2
                })
            }
        case 2:
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.detailView.frame                               = self.detailViewOriginalFrame!
                self.foldDownButton.frame                           = self.foldDownButtonOriginalFrame!
                self.foldDownFunctionButton.frame                   = self.foldDownButtonOriginalFrame!
                self.foldUpButton.hidden                            = false
                self.foldUpFunctionButton.hidden                    = false
                self.foldDownButton.hidden                          = false
                self.foldDownFunctionButton.hidden                  = false
                }, completion: {
                    (finished: Bool) -> Void in
                    self.displayerMode                              = 1
            })

        default:
            return
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    func buttonBreathEffect() {
    //----------------------------------------------------------------------------------------------------------
        isAnimatingBreathing = true
        UIView.animateWithDuration(1, delay: 0.4, options: .CurveEaseOut, animations: {
            if self.foldUpButton.alpha == 1 {
                self.foldUpButton.alpha = 0.1
            } else {
                self.foldUpButton.alpha = 1
            }
            
            if self.foldDownButton.alpha == 1 {
                self.foldDownButton.alpha = 0.1
            } else {
                self.foldDownButton.alpha = 1
            }
            
            }, completion: nil)
    }
    
    // MapView
    //----------------------------------------------------------------------------------------------------------
    func configMapView()
    //----------------------------------------------------------------------------------------------------------
    {
        mapView.delegate                                            = self
        manager                                                     = CLLocationManager()
        manager.delegate                                            = self
        manager.desiredAccuracy                                     = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
        
        addAnnotations()
    }
    
    //----------------------------------------------------------------------------------------------------------
    func centerMapOnUser()
    //----------------------------------------------------------------------------------------------------------
    {
        let latitude                                                = manager.location.coordinate.latitude
        let longitude                                               = manager.location.coordinate.longitude
        let location: CLLocationCoordinate2D                        = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let regionRadius: CLLocationDistance                        = 200
        let coordinateRegion                                        = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func centerMapOnFavor()
    //----------------------------------------------------------------------------------------------------------
    {
        let location: CLLocationCoordinate2D                        = annotations[index].coordinate
        let regionRadius: CLLocationDistance                        = 100
        let coordinateRegion                                        = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func addAnnotations()
    //----------------------------------------------------------------------------------------------------------
    {
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
    
    // TableView
    //----------------------------------------------------------------------------------------------------------
    func configContainerView()
    //----------------------------------------------------------------------------------------------------------
    {
        detailView.userInteractionEnabled = true
        addSwipeGesturesToDetailView()
        
        tableView = childViewControllers.last as? FavorDetailTable
        tableView?.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "fullScreenImageScroller")
        tableView!.imageScrollView.addGestureRecognizer(tapGesture)
        tableView!.bindData(favors[index] as! PFObject)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func fullScreenImageScroller()
    //----------------------------------------------------------------------------------------------------------
    {
        var imageView                                   = UIImageView(frame: tableView!.imageScrollView.layer.frame)
        imageView.image                                 = tableView?.images[tableView!.pageControl.currentPage]
        imageView.alpha = 0
        imageView.userInteractionEnabled = true
        view.addSubview(imageView)
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            imageView.alpha = 1
            imageView.frame = self.view.frame
            }, completion: {
                (finished: Bool) -> Void in
        })
    
        var tapGesture                                  = UITapGestureRecognizer(target: self, action: "dismissFullScreenImageScroller:")
        imageView.addGestureRecognizer(tapGesture)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func dismissFullScreenImageScroller(sender: UITapGestureRecognizer)
    //----------------------------------------------------------------------------------------------------------
    {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            sender.view?.alpha = 0
            }, completion: {
                (finished: Bool) -> Void in
                sender.view?.removeFromSuperview()
        })
    }
    
    
    // MARK: - Delegates
    //----------------------------------------------------------------------------------------------------------
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    //----------------------------------------------------------------------------------------------------------
    {
        if !isCenteredOnUserLocation
        {
            centerMapOnUser()
            isCenteredOnUserLocation = !isCenteredOnUserLocation
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    //----------------------------------------------------------------------------------------------------------
    {
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
}











