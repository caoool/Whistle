//
//  FavorDetailTable.swift
//  Whistle
//
//  Created by Lu Cao on 6/24/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

//----------------------------------------------------------------------------------------------------------
import UIKit
import Parse
//----------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------
class FavorDetailTable: UITableViewController
    //----------------------------------------------------------------------------------------------------------
{
    // MARK: - IBOutlets
    
    //----------------------------------------------------------------------------------------------------------
    // Price
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var priceIcon                                    : UIImageView!
    @IBOutlet weak var priceLine                                    : UIView!
    @IBOutlet weak var dollarLabel                                  : UILabel!
    @IBOutlet weak var priceLabel                                   : UILabel!
    @IBOutlet weak var plus1Button                                  : UIButton!
    @IBOutlet weak var plus5Button                                  : UIButton!
    @IBOutlet weak var plus10Button                                 : UIButton!
    @IBOutlet weak var clearButton                                  : UIButton!
    //----------------------------------------------------------------------------------------------------------
    // Rewards
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var rewardIcon                                   : UIImageView!
    @IBOutlet weak var rewardLine                                   : UIView!
    @IBOutlet weak var rewardLabel                                  : UILabel!
    //----------------------------------------------------------------------------------------------------------
    // Favor
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var favorIcon                                    : UIImageView!
    @IBOutlet weak var favorLine                                    : UIView!
    @IBOutlet weak var favorLabel                                   : UILabel!
    //----------------------------------------------------------------------------------------------------------
    // Address
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var addressIcon                                  : UIImageView!
    @IBOutlet weak var addressLine                                  : UIView!
    @IBOutlet weak var addressLabel                                 : UILabel!
    //----------------------------------------------------------------------------------------------------------
    // Images
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var imagesIcon                                   : UIImageView!
    @IBOutlet weak var imagesLine                                   : UIView!
    @IBOutlet weak var image0                                       : UIImageView!
    @IBOutlet weak var image1                                       : UIImageView!
    @IBOutlet weak var image2                                       : UIImageView!
    //----------------------------------------------------------------------------------------------------------
    
    
    
    
    // MARK: - Variables
    
    //----------------------------------------------------------------------------------------------------------
    // Parse
    //----------------------------------------------------------------------------------------------------------
    var favor                                                       : PFObject!
    //----------------------------------------------------------------------------------------------------------
    // Defaults
    //----------------------------------------------------------------------------------------------------------
    var defaultPrice                                                : String?
    //----------------------------------------------------------------------------------------------------------
    // Audio
    //----------------------------------------------------------------------------------------------------------
    var audioAsset                                                  = AVURLAsset()
    var playerView                                                  = SYWaveformPlayerView()
    //----------------------------------------------------------------------------------------------------------
    // Images
    //----------------------------------------------------------------------------------------------------------
    var images                                                      = [UIImage]()
    var imageViews                                                  = [UIImageView]()
    //----------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Initializations
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
        //----------------------------------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        configDefaults()
        //        configAudio()
        //        configAudioView()
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func viewDidAppear(animated: Bool)
        //----------------------------------------------------------------------------------------------------------
    {
        super.viewDidAppear(true)
        tableView.reloadData()
        scrollToTop()
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLayoutSubviews()
        //----------------------------------------------------------------------------------------------------------
    {
        configLooks()
        configShape()
    }
    
    
    // MARK: - IBActions
    //----------------------------------------------------------------------------------------------------------
    @IBAction func modifyPrice(sender: UIButton)
        //----------------------------------------------------------------------------------------------------------
    {
        tableView.bringSubviewToFront(sender)
        bounceView(sender)
        bounceView(priceLabel)
        switch sender.titleLabel!.text! {
        case "C":
            priceLabel.text = defaultPrice
        case "+10":
            priceLabel.text = "\(priceLabel.text!.toInt()! + 10)"
        case "+5":
            priceLabel.text = "\(priceLabel.text!.toInt()! + 5)"
        case "+1":
            priceLabel.text = "\(priceLabel.text!.toInt()! + 1)"
        default:
            return
        }
    }
    
    
    // MARK: - Functionalities
    //----------------------------------------------------------------------------------------------------------
    func bindData(favor : PFObject)
        //----------------------------------------------------------------------------------------------------------
    {
        var user : PFUser = favor[Constants.Favor.CreatedBy] as! PFUser
        var file = user[Constants.User.Portrait] as! PFFile
        self.favorLabel.text = favor[Constants.Favor.Content] as? String
        self.rewardLabel.text = favor[Constants.Favor.Reward] as? String
        let images = favor[Constants.Favor.Image] as? NSArray
        if images != nil {
            for image in images! {
                image.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if error == nil {
                        let imagee = UIImage(data: data!)
                        self.images.append(imagee!)
                        if self.images.count == images!.count {
                            
                        }
                    }
                })
            }
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configLooks()
        //----------------------------------------------------------------------------------------------------------
    {
        tableView.backgroundColor                                   = Constants.Color.Background
        
        var shadowOffset                                            = CGSizeMake(0, -1)
        var labelList                                               = [dollarLabel, priceLabel, rewardLabel, favorLabel, addressLabel]
        for element in labelList {
            element.textColor                                       = Constants.Color.CellText
            element.shadowColor                                     = Constants.Color.CellTextShadow
            element.shadowOffset                                    = CGSizeMake(0, -1)
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configDefaults()
        //----------------------------------------------------------------------------------------------------------
    {
        defaultPrice                                                = priceLabel.text
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configShape()
        //----------------------------------------------------------------------------------------------------------
    {
        var buttonList = [plus1Button, plus5Button, plus10Button, clearButton]
        for element in buttonList {
            element.layer.borderColor                               = Constants.Color.Border.CGColor
            element.layer.borderWidth                               = 0.3
            element.layer.cornerRadius                              = element.layer.frame.height/2
            element.setTitleColor(Constants.Color.CellText, forState: .Normal)
        }
        
        var iconList = [priceIcon, rewardIcon, favorIcon, addressIcon, imagesIcon]
        for element in iconList {
            tableView.bringSubviewToFront(element)
            element.layer.borderColor                               = Constants.Color.Border.CGColor
            element.layer.borderWidth                               = 2
            element.layer.cornerRadius                              = element.layer.frame.height/2
        }
        
        var lineList = [priceLine, rewardLine, favorLine, addressLine, imagesLine]
        for element in lineList {
            element.backgroundColor                                 = Constants.Color.Border
        }
        
        reshapeImageView()
        reshapeAudioView()
    }
    
    //----------------------------------------------------------------------------------------------------------
    // Called when in display mode 2
    //----------------------------------------------------------------------------------------------------------
    func setTopMargin2()
        //----------------------------------------------------------------------------------------------------------
    {
        tableView.contentInset                                      = UIEdgeInsetsMake(170, 0, YALTabBarViewDefaultHeight + 30, 0)
    }
    
    //----------------------------------------------------------------------------------------------------------
    // Called when in display mode 1
    //----------------------------------------------------------------------------------------------------------
    func setTopMargin1()
        //----------------------------------------------------------------------------------------------------------
    {
        tableView.contentInset                                      = UIEdgeInsetsMake(100, 0, YALTabBarViewDefaultHeight + 30, 0)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func scrollToTop()
        //----------------------------------------------------------------------------------------------------------
    {
        tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
    }
    
    //----------------------------------------------------------------------------------------------------------
    // START: - Audio
    //----------------------------------------------------------------------------------------------------------
    func configAudio()
        //----------------------------------------------------------------------------------------------------------
    {
        audioAsset = AVURLAsset(URL: NSBundle.mainBundle().URLForResource("test audio", withExtension: "mp3"), options: nil)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configAudioView()
        //----------------------------------------------------------------------------------------------------------
    {
        //        playerView = SYWaveformPlayerView(frame: audioView.frame, asset: audioAsset, color: Constants.Color.AudioViewColor, progressColor: Constants.Color.AudioViewProgressColor)
        //        audioView.addSubview(playerView)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func reshapeAudioView()
        //----------------------------------------------------------------------------------------------------------
    {
        //        playerView.frame = audioView.frame
    }
    //----------------------------------------------------------------------------------------------------------
    // END: - Audio
    //----------------------------------------------------------------------------------------------------------
    
    //----------------------------------------------------------------------------------------------------------
    func configImages()
        //----------------------------------------------------------------------------------------------------------
    {
        images.append(UIImage(named: "Portrait_Test")!)
        images.append(UIImage(named: "finished_indicator_favor")!)
        images.append(UIImage(named: "Portrait_Test")!)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configImageView()
        //----------------------------------------------------------------------------------------------------------
    {
        //        let scrollViewWidth: CGFloat = imageScrollView.frame.width
        //        let scrollViewHeight: CGFloat = imageScrollView.frame.height
        //
        //        for (index, element) in enumerate(images) {
        //            var imageView = UIImageView(image: element)
        //            imageView.frame = CGRectMake(scrollViewWidth*CGFloat(index), 0, scrollViewWidth, scrollViewHeight)
        //            imageView.userInteractionEnabled = true
        //            imageViews.append(imageView)
        //            imageScrollView.addSubview(imageView)
        //        }
        //
        //        imageScrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(images.count), scrollViewHeight)
        //        imageScrollView.delegate = self
        //        pageControl.numberOfPages = images.count
        //        pageControl.currentPage = 0
    }
    
    //----------------------------------------------------------------------------------------------------------
    func reshapeImageView()
        //----------------------------------------------------------------------------------------------------------
    {
        //        let scrollViewWidth: CGFloat = imageScrollView.frame.width
        //        let scrollViewHeight: CGFloat = imageScrollView.frame.height
        //
        //        for (index, element) in enumerate(imageViews) {
        //            element.frame = CGRectMake(scrollViewWidth*CGFloat(index), 0, scrollViewWidth, scrollViewHeight)
        //        }
        //
        //        imageScrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(images.count), scrollViewHeight)
    }
    
    
    // MARK: - Delegations
    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
        //----------------------------------------------------------------------------------------------------------
    {
        switch indexPath.section {
        case 0:                                                     // Price
            return 85
        case 1:                                                     // Reward
            return calculateHeightForString(rewardLabel.text!) + 100
        case 2:                                                     // Favor
            return calculateHeightForString(favorLabel.text!) + 100
        case 3:                                                     // Address
            return calculateHeightForString(addressLabel.text!) + 100
        case 4:                                                     // Images
            return 30 + image0.frame.height
        default:
            return 44
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    // Modify cell height and background color
    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        //----------------------------------------------------------------------------------------------------------
    {
        var cell                        = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.backgroundColor            = Constants.Color.Background
        return cell
    }
    
    
}










