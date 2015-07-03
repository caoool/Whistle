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
    // Navigation Bar
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var navBarItemLeft                   : UIBarButtonItem!
    @IBOutlet weak var navBarItemRight                  : UIBarButtonItem!
    //----------------------------------------------------------------------------------------------------------
    // Map
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var mapView                          : MKMapView!
    @IBOutlet weak var foldUpButton                     : UIButton!
    @IBOutlet weak var foldUpFunctionButton             : UIButton!
    @IBOutlet weak var centerOnUserButton               : UIButton!
    //----------------------------------------------------------------------------------------------------------
    // Table
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var detailView                       : UIView!
    @IBOutlet weak var foldDownButton                   : UIButton!
    @IBOutlet weak var foldDownFunctionButton           : UIButton!
    //----------------------------------------------------------------------------------------------------------
    // Portrait
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var portraitView                     : UIView!
    @IBOutlet weak var portraitImageView                : UIImageView!
    
    //----------------------------------------------------------------------------------------------------------
    // Constraints
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var mapViewHeightConstraint          : NSLayoutConstraint!
    @IBOutlet weak var mapViewBottomConstraint          : NSLayoutConstraint!
    @IBOutlet weak var foldUpBottomConstraint           : NSLayoutConstraint!
    @IBOutlet weak var foldUpBottomNewConstraint        : NSLayoutConstraint!
    @IBOutlet weak var centerOnUserBottomConstraint     : NSLayoutConstraint!
    @IBOutlet weak var centerOnUserBottomNewConstraint  : NSLayoutConstraint!
    @IBOutlet weak var portraitViewTopConstraint        : NSLayoutConstraint!
    @IBOutlet weak var portraitViewNewTopConstraint     : NSLayoutConstraint!
    @IBOutlet weak var portraitViewCenterConstraint     : NSLayoutConstraint!
    @IBOutlet weak var portraitViewOffConstraint        : NSLayoutConstraint!
    //----------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Variables
    //----------------------------------------------------------------------------------------------------------
    private var timer                                   : NSTimer?
    private var interested                              = false
    
    private var manager                                 : CLLocationManager!
    private var isCenteredOnUserLocation                = false
    private var annotations                             = [CustomPointAnnotation]()
    private var tableView                               : FavorDetailTable?
    //----------------------------------------------------------------------------------------------------------
    private var displayerMode                           : Int = 1   // 0: all map; 1: Splitted; 2: all table
    private var mapViewOriginalFrame                    : CGRect?
    private var detailViewOriginalFrame                 : CGRect?
    private var foldUpButtonOriginalFrame               : CGRect?
    private var foldDownButtonOriginalFrame             : CGRect?
    private var centerOnUserButtonOriginalFrame         : CGRect?
    private var portraitViewOriginalFrame               : CGRect?
    //----------------------------------------------------------------------------------------------------------
    private var isAnimatingDisplay                      = false
    private var isAnimatingBreathing                    = false
    private var didLayoutSubviews                       = false
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
        
        configLooks()
        if !isAnimatingBreathing {
            timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "buttonBreathEffect", userInfo: nil, repeats: true)
        }
        
        if didLayoutSubviews {
            displayerMode                               = 0
        }
        
        self.mapViewHeightConstraint.active             = false
        self.mapViewBottomConstraint.active             = true
        self.foldUpBottomConstraint.active              = false
        self.foldUpBottomNewConstraint.active           = true
        self.centerOnUserBottomConstraint.active        = false
        self.centerOnUserBottomNewConstraint.active     = true
        portraitView.alpha                              = 0
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLayoutSubviews()
        //----------------------------------------------------------------------------------------------------------
    {
        configShapes()
        if !didLayoutSubviews {
            self.mapViewOriginalFrame                       = self.mapView.frame
            self.foldUpButtonOriginalFrame                  = self.foldUpButton.frame
            self.centerOnUserButtonOriginalFrame            = self.centerOnUserButton.frame
            self.detailViewOriginalFrame                    = self.detailView.frame
            self.foldDownButtonOriginalFrame                = self.foldDownButton.frame
            self.portraitViewOriginalFrame                  = self.portraitView.frame
            changeDisplayMode(0)
            didLayoutSubviews = true
        }
        
    }
    
    
    // MARK: - IBActions
    //----------------------------------------------------------------------------------------------------------
    // Navigation Bar
    //----------------------------------------------------------------------------------------------------------
    @IBAction func navBarItemLeftTapped(sender: UIBarButtonItem)
        //----------------------------------------------------------------------------------------------------------
    {
        performSegueWithIdentifier("FavorView_To_FavorListTable", sender: self)
    }
    
    //----------------------------------------------------------------------------------------------------------
    @IBAction func navBarItemRightTapped(sender: UIBarButtonItem)
        //----------------------------------------------------------------------------------------------------------
    {
        performSegueWithIdentifier("FavorView_To_FavorSearchConditionTable", sender: self)
    }
    
    //----------------------------------------------------------------------------------------------------------
    // Map
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
    
    
    // MARK: - User interactions
    //----------------------------------------------------------------------------------------------------------
    func addGestures()
        //----------------------------------------------------------------------------------------------------------
    {
        var swipeRight              = UISwipeGestureRecognizer(target: self, action: "respondToGestures:")
        swipeRight.direction        = UISwipeGestureRecognizerDirection.Right
        detailView.addGestureRecognizer(swipeRight)
        portraitImageView.addGestureRecognizer(swipeRight)
        
        var swipeLeft               = UISwipeGestureRecognizer(target: self, action: "respondToGestures:")
        swipeLeft.direction         = UISwipeGestureRecognizerDirection.Left
        detailView.addGestureRecognizer(swipeLeft)
        portraitImageView.addGestureRecognizer(swipeLeft)
        
        var swipeUp                 = UISwipeGestureRecognizer(target: self, action: "respondToGestures:")
        swipeUp.direction           = UISwipeGestureRecognizerDirection.Up
        portraitImageView.addGestureRecognizer(swipeUp)
        
        var swipeDown               = UISwipeGestureRecognizer(target: self, action: "respondToGestures:")
        swipeDown.direction         = UISwipeGestureRecognizerDirection.Down
        portraitImageView.addGestureRecognizer(swipeDown)
        
        var tap                     = UITapGestureRecognizer(target: self, action: "respondToGestures:")
        portraitImageView.addGestureRecognizer(tap)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func respondToGestures(gesture: UIGestureRecognizer)
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
            case UISwipeGestureRecognizerDirection.Up:
                displayerMode == 2 ? print() : changeDisplayMode(2)
            case UISwipeGestureRecognizerDirection.Down:
                displayerMode == 2 ? changeDisplayMode(1) : changeDisplayMode(0)
            default:
                break
            }
        }
        if let tapGesture = gesture as? UITapGestureRecognizer {
            
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
        configMapView()
        configContainerView()
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
        view.backgroundColor                                        = Constants.Color.Background
        portraitView.backgroundColor                                = UIColor.clearColor()
        detailView.addTopBorderWithHeight(3, color: Constants.Color.Border)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configShapes()
        //----------------------------------------------------------------------------------------------------------
    {
        portraitImageView.layer.borderColor                         = Constants.Color.Border.CGColor
        portraitImageView.layer.borderWidth                         = 3
        portraitImageView.layer.cornerRadius                        = portraitImageView.frame.height/2
    }
    
    //----------------------------------------------------------------------------------------------------------
    func changeDisplayMode(mode: Int)
        //----------------------------------------------------------------------------------------------------------
    {
        if isAnimatingDisplay { return }
        
        var tabBarHeight = YALTabBarViewDefaultHeight
        var naviBarHeight = navigationController?.navigationBar.frame.height
        
        switch displayerMode {
        case 0:
            self.isAnimatingDisplay                                 = true
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.mapViewBottomConstraint.active                 = false
                self.mapView.frame                                  = self.mapViewOriginalFrame!
                self.mapViewHeightConstraint.active                 = true
                
                self.foldUpBottomNewConstraint.active               = false
                self.foldUpButton.frame                             = self.foldUpButtonOriginalFrame!
                self.foldUpFunctionButton.frame                     = self.foldUpButtonOriginalFrame!
                self.foldUpBottomConstraint.active                  = true
                
                self.centerOnUserBottomNewConstraint.active         = false
                self.centerOnUserButton.frame                       = self.centerOnUserButtonOriginalFrame!
                self.centerOnUserBottomConstraint.active            = true
                
                self.portraitViewOffConstraint.active               = false
                self.portraitView.alpha                             = 1
                self.portraitView.frame.origin.x                    = self.view.frame.origin.x
                self.portraitViewCenterConstraint.active            = true
                
                self.detailView.alpha                               = 1
                self.foldDownButton.hidden                          = true
                self.foldDownFunctionButton.hidden                  = true
                self.foldUpButton.hidden                            = true
                self.foldUpFunctionButton.hidden                    = true
                
                
                }, completion: {
                    (finished: Bool) -> Void in
                    self.displayerMode                              = 1
                    self.isAnimatingDisplay                         = false
                    self.tableView?.setTopMargin1()
                    self.tableView?.scrollToTop()
            })
        case 1:
            self.isAnimatingDisplay                                 = true
            if mode == 0 {
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.mapViewHeightConstraint.active             = false
                    self.mapView.frame                              = CGRectMake(0, naviBarHeight!, self.view.frame.width, self.view.frame.height - naviBarHeight!)
                    self.mapViewBottomConstraint.active             = true
                    
                    self.foldUpBottomConstraint.active              = false
                    self.foldUpBottomNewConstraint.active           = true
                    
                    self.centerOnUserBottomConstraint.active        = false
                    self.centerOnUserBottomNewConstraint.active     = true
                    
                    self.portraitViewCenterConstraint.active        = false
                    self.portraitView.alpha                         = 0
                    self.portraitView.frame                         = self.portraitViewOriginalFrame!
                    self.portraitViewOffConstraint.active           = true
                    
                    self.detailView.alpha                           = 0
                    self.foldUpButton.hidden                        = false
                    self.foldUpFunctionButton.hidden                = false
                    self.foldDownButton.hidden                      = true
                    self.foldDownFunctionButton.hidden              = true
                    }, completion: {
                        (finished: Bool) -> Void in
                        self.displayerMode = 0
                        self.isAnimatingDisplay                     = false
                })
            }
            if mode == 2 {
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.detailView.alpha                           = 1
                    self.foldUpButton.hidden                        = true
                    self.foldUpFunctionButton.hidden                = true
                    self.foldDownButton.hidden                      = true
                    self.foldDownFunctionButton.hidden              = true
                    self.foldDownButton.layer.frame.origin.y        = self.view.frame.origin.y + naviBarHeight! + 30
                    self.foldDownFunctionButton.layer.frame.origin.y = self.view.frame.origin.y + naviBarHeight! + 30
                    //                    self.portraitViewTopConstraint.active           = false
                    self.portraitView.layer.frame.origin.y          = self.view.layer.frame.origin.y + naviBarHeight! + 30
                    self.detailView.frame                           = CGRectMake(0, naviBarHeight!, self.view.frame.width, self.view.frame.height - naviBarHeight!)
                    //                    self.portraitViewNewTopConstraint.active        = true
                    }, completion: {
                        (finished: Bool) -> Void in
                        self.displayerMode                          = 2
                        self.isAnimatingDisplay                     = false
                        self.tableView?.setTopMargin2()
                        self.tableView?.scrollToTop()
                })
            }
        case 2:
            self.isAnimatingDisplay                                 = true
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.portraitView.frame                             = self.portraitViewOriginalFrame!
                self.portraitView.frame.origin.x                    = self.view.frame.origin.x
                
                self.detailView.frame                               = self.detailViewOriginalFrame!
                self.foldDownButton.frame                           = self.foldDownButtonOriginalFrame!
                self.foldDownFunctionButton.frame                   = self.foldDownButtonOriginalFrame!
                self.foldUpButton.hidden                            = true
                self.foldUpFunctionButton.hidden                    = true
                self.foldDownButton.hidden                          = true
                self.foldDownFunctionButton.hidden                  = true
                self.tableView?.setTopMargin1()
                }, completion: {
                    (finished: Bool) -> Void in
                    self.displayerMode                              = 1
                    self.isAnimatingDisplay                         = false
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
        addGestures()
        
        tableView = childViewControllers.last as? FavorDetailTable
        tableView?.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        tableView!.bindData(favors[index] as! PFObject)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func fullScreenImageScroller()
        //----------------------------------------------------------------------------------------------------------
    {
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











