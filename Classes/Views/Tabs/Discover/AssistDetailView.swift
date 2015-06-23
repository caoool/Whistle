//
//  OrderDetailVC.swift
//  Arrived
//
//  Created by Lu Cao on 5/30/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import Parse

class AssistDetailView: UIViewController, UIScrollViewDelegate {
    
    var favor : PFObject?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // price view
    @IBOutlet weak var priceLabel: UICountingLabel!
    @IBOutlet weak var priceLabeBackgroundView: UIView!
    private var currentPrice: Double?
    
    private var interested = false
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var interestedButton: UIButton!
    
    @IBOutlet weak var plus1Button: UIButton!
    @IBOutlet weak var plus5Button: UIButton!
    @IBOutlet weak var plus10Button: UIButton!
    @IBOutlet weak var clearAddedMoneyButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var midButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    // detail view
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var startLeftView: UILabel!
    
    @IBOutlet weak var titleLeftView: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLeftView: UILabel!
    
    // user view
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // media view
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var mediaScrollView: UIScrollView!
    @IBOutlet weak var mediaPageControl: UIPageControl!
    
    private var testImageViews = [UIImageView]()
    
    private var textColor: UIColor?
    
    private var isInitiated = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollViewWidth: CGFloat = mediaScrollView.frame.width
        let scrollViewHeight: CGFloat = mediaScrollView.frame.height
        
        var imageView1 = UIImageView(image: UIImage(named: "image1.jpg"))
        imageView1.frame = CGRectMake(0, 30, scrollViewWidth, scrollViewHeight)
        var imageView2 = UIImageView(image: UIImage(named: "image2.jpg"))
        imageView2.frame = CGRectMake(scrollViewWidth, 30, scrollViewWidth, scrollViewHeight)
        var imageView3 = UIImageView(image: UIImage(named: "image3.jpg"))
        imageView3.frame = CGRectMake(scrollViewWidth*2, 30, scrollViewWidth, scrollViewHeight)
        testImageViews = [imageView1, imageView2, imageView3]
        
        for item in testImageViews {
            mediaScrollView.addSubview(item)
        }
        mediaScrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(testImageViews.count), scrollViewHeight)
        mediaScrollView.delegate = self
        mediaPageControl.currentPage = 0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initScene()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isInitiated {
            isInitiated = true
            var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            var blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = backgroundImageView.bounds
            backgroundImageView.addSubview(blurView)
            
            priceLabeBackgroundView.layer.borderWidth = 1.5
            priceLabeBackgroundView.layer.borderColor = UIColor.whiteColor().CGColor
            priceLabeBackgroundView.layer.cornerRadius = priceLabeBackgroundView.layer.bounds.height/2
            var blurEffect2 = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            var blurView2 = UIVisualEffectView(effect: blurEffect2)
            blurView2.frame = priceLabeBackgroundView.bounds
            priceLabeBackgroundView.addSubview(blurView2)
            priceLabeBackgroundView.alpha = 0.15
            
            var timer1 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("priceBounce"), userInfo: nil, repeats: false)
            
            leftButton.roundCorners(.TopLeft | .BottomLeft, radius: 9)
            rightButton.roundCorners(.TopRight | .BottomRight, radius: 9)
            
            leftButton.alpha = 0.65
            midButton.alpha = 0.65
            rightButton.alpha = 0.65
            
            plus1Button.layer.borderColor = UIColor.whiteColor().CGColor
            plus1Button.layer.borderWidth = 1.2
            plus1Button.layer.cornerRadius = plus1Button.layer.bounds.height/2
            
            plus5Button.layer.borderColor = UIColor.whiteColor().CGColor
            plus5Button.layer.borderWidth = 1.2
            plus5Button.layer.cornerRadius = plus1Button.layer.bounds.height/2
            
            plus10Button.layer.borderColor = UIColor.whiteColor().CGColor
            plus10Button.layer.borderWidth = 1.2
            plus10Button.layer.cornerRadius = plus1Button.layer.bounds.height/2
            
            drawLineFromPoint(plus1Button.center, toPoint: plus5Button.center, ofColor: UIColor.whiteColor(), inView: view)
            drawLineFromPoint(plus5Button.center, toPoint: plus10Button.center, ofColor: UIColor.whiteColor(), inView: view)
            view.bringSubviewToFront(plus1Button)
            view.bringSubviewToFront(plus5Button)
            view.bringSubviewToFront(plus10Button)
            
            titleLeftView.layer.borderColor = UIColor.lightGrayColor().CGColor
            titleLeftView.layer.borderWidth = 0.65
            titleLeftView.layer.cornerRadius = 2
            
            detailLeftView.layer.borderColor = UIColor.lightGrayColor().CGColor
            detailLeftView.layer.borderWidth = 0.65
            detailLeftView.layer.cornerRadius = 2
            
            startLeftView.layer.borderColor = UIColor.lightGrayColor().CGColor
            startLeftView.layer.borderWidth = 0.65
            startLeftView.layer.cornerRadius = 2
            
            //            endLeftView.layer.borderColor = UIColor.lightGrayColor().CGColor
            //            endLeftView.layer.borderWidth = 0.65
            //            endLeftView.layer.cornerRadius = 2
            
            let newImage = mapButton.imageView?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            mapButton.tintColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:0.5)
            mapButton.setImage(newImage, forState: .Normal)

            let newImage2 = interestedButton.imageView?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            interestedButton.tintColor = UIColor.lightGrayColor()
            interestedButton.setImage(newImage2, forState: .Normal)
            
            portraitImageView.layer.borderWidth = 1.5
            portraitImageView.layer.borderColor = UIColor.whiteColor().CGColor
            portraitImageView.layer.cornerRadius = 12
        }
    }
    
    func priceBounce() {
        bounceView(priceLabel)
    }
    
    func initScene() {
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        textColor = leftButton.titleLabel?.textColor
        midButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        midButton.backgroundColor = UIColor(red:0.63, green:0.62, blue:0.89, alpha:1)
        
        // Binding Data
        var user : PFUser = favor![Constants.Favor.User] as! PFUser
        var file = user[Constants.User.Portrait] as? PFFile
        file?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                self.portraitImageView.image = UIImage(data: data!)!
            }
        })
    
        self.nicknameLabel.text = user[Constants.User.Nickname] as? String
        self.statusLabel.text = user[Constants.User.Status] as? String
        
        self.titleLabel.text = favor![Constants.Favor.Content] as? String
        self.currentPrice = favor![Constants.Favor.Price] as? Double
        self.priceLabel.text = "$ \(self.currentPrice!)"
        self.priceLabel.layer.backgroundColor = UIColorFromHex(0x000000, alpha: 0.02).CGColor
        
        // user view
        leftView.alpha = 0
        
        // media view
        rightView.alpha = 0
    }
    
    @IBAction func addressButtonTapped(sender: UIButton) {
        bounceView(sender)
        let viewController = ContentViewController()
//        viewController.toPass = toPass!.address!
//        viewController.latitude = toPass!.latitude!
//        viewController.longitude = toPass!.longitude!
        let alert = AlertController(view: viewController.view, style: .ActionSheet)
        showAlert(alert)
    }

    @IBAction func buttonTapped(sender: UIButton) {
        switch sender.titleLabel!.text! {
        case "User":
            UIView.animateWithDuration(0.65, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.leftButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.leftButton.backgroundColor = UIColor(red:0.63, green:0.62, blue:0.89, alpha:1)
                self.midButton.setTitleColor(self.textColor, forState: .Normal)
                self.midButton.backgroundColor = UIColor.whiteColor()
                self.rightButton.setTitleColor(self.textColor, forState: .Normal)
                self.rightButton.backgroundColor = UIColor.whiteColor()
                self.midView.alpha = 0
                self.leftView.alpha = 1
                self.rightView.alpha = 0
                }, completion: nil)
        case "Detail":
            UIView.animateWithDuration(0.65, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.midButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.midButton.backgroundColor = UIColor(red:0.63, green:0.62, blue:0.89, alpha:1)
                self.leftButton.setTitleColor(self.textColor, forState: .Normal)
                self.leftButton.backgroundColor = UIColor.whiteColor()
                self.rightButton.setTitleColor(self.textColor, forState: .Normal)
                self.rightButton.backgroundColor = UIColor.whiteColor()
                self.midView.alpha = 1
                self.leftView.alpha = 0
                self.rightView.alpha = 0
                }, completion: nil)
        case "Media":
            UIView.animateWithDuration(0.65, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.rightButton.backgroundColor = UIColor(red:0.63, green:0.62, blue:0.89, alpha:1)
                self.midButton.setTitleColor(self.textColor, forState: .Normal)
                self.midButton.backgroundColor = UIColor.whiteColor()
                self.leftButton.setTitleColor(self.textColor, forState: .Normal)
                self.leftButton.backgroundColor = UIColor.whiteColor()
                self.midView.alpha = 0
                self.leftView.alpha = 0
                self.rightView.alpha = 1
                }, completion: nil)
        default:
            break
        }
    }
    
    
    @IBAction func interestedButtonTapped(sender: UIButton) {
        bounceView(sender)
        if !interested {
            interested = !interested
            let newImage = sender.imageView?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            sender.tintColor = UIColor(red:0.95, green:0.69, blue:0.25, alpha:0.6)
            sender.setImage(newImage, forState: .Normal)
            
            let relation = favor!.relationForKey(Constants.Favor.Interested)
            relation.addObject(PFUser.currentUser()!)
            favor!.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    println("send interest success")
                } else {
                    println("failed")
                }
            })
            
        } else {
            interested = !interested
            let newImage = sender.imageView?.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            sender.tintColor = UIColor.lightGrayColor()
            sender.setImage(newImage, forState: .Normal)
            let relation = favor!.relationForKey(Constants.Favor.Interested)
            relation.removeObject(PFUser.currentUser()!)
            favor!.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    println("send interest success")
                } else {
                    println("failed")
                }
            })
        }
    }
    
    
    
    func showAlert(alert: SimpleAlert.Controller) {
        
        alert.addAction(SimpleAlert.Action(title: "Navigate", style: .Destructive) { action in
            })
        
        alert.addAction(SimpleAlert.Action(title: "OK", style: .OK) { action in
            })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func plusMoney(sender: UIButton) {
        if !interested {
            switch sender.titleLabel!.text! {
            case "+1":
                priceLabel.text = "$ \(currentPrice! + 1)"
                currentPrice! += 1
                bounceView(priceLabel)
            case "+5":
                priceLabel.text = "$ \(currentPrice! + 5)"
                currentPrice! += 5
                bounceView(priceLabel)
            case "+10":
                priceLabel.text = "$ \(currentPrice! + 10)"
                currentPrice! += 10
                bounceView(priceLabel)
            default:
                break
            }
        }
    }
    
    @IBAction func clearAddedMoney(sender: UIButton) {
        self.priceLabel.text = "$ \(favor![Constants.Favor.Price] as? Double)"
        bounceView(priceLabel)
    }
    
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView) {
        
        //design the path
        var path = UIBezierPath()
        path.moveToPoint(start)
        path.addLineToPoint(end)
        
        //design path in layer
        var shapeLayer = CAShapeLayer()
        shapeLayer.path = path.CGPath
        shapeLayer.strokeColor = lineColor.CGColor
        shapeLayer.lineWidth = 2
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        var pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        var currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        mediaPageControl.currentPage = Int(currentPage);
    }
    
    func bindData(favor : PFObject) {
        
        var user : PFUser = favor[Constants.Favor.User] as! PFUser
        var file = user[Constants.User.Portrait] as? PFFile
        file?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                self.portraitImageView.image = UIImage(data: data!)!
            }
        })

        self.nicknameLabel.text = user[Constants.User.Nickname] as? String
        self.statusLabel.text = user[Constants.User.Status] as? String
        
        self.titleLabel.text = favor[Constants.Favor.Content] as? String
        self.currentPrice = favor[Constants.Favor.Price] as? Double
        self.priceLabel.text = "$ \(self.currentPrice)"
        self.priceLabel.layer.backgroundColor = UIColorFromHex(0x000000, alpha: 0.02).CGColor
        
        //startTimeLabel.text = toPass!.effectiveStartDate
        //endTimeLabel.text = toPass!.effectiveEndDate
    
//        
//        let likes = user[Constants.User.Likes] as! Int
//        let dislikes = user[Constants.User.Dislikes] as! Int
//        
//        reviewLabel.text = "❤️ \(likes) 💔 \(dislikes)"
//        
//        let manager = CLLocationManager()
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//            manager.startUpdatingLocation()
//            
//            let latitude = manager.location.coordinate.latitude
//            let longitude = manager.location.coordinate.longitude
//            let location = CLLocation(latitude: latitude, longitude: longitude)
//            
//            let currentLocation = PFGeoPoint(location: location)
//            let distance = currentLocation.distanceInMilesTo(favor[Constants.Favor.Location] as? PFGeoPoint)
//            self.distanceLabel.text = "\(Int(distance)) miles"
//            
//            switch favor[Constants.Favor.Status] as! Int {
//            case 0:
//                self.status.image = self.indicatorDefault
//            case 1:
//                self.status.image = self.indicatorProgressing
//            case 2:
//                self.status.image = self.indicatorFinished
//            default:
//                break
//            }
//        }
        
    }

}





















