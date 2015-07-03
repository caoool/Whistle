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
class FavorDetailTable: UITableViewController, UIScrollViewDelegate
//----------------------------------------------------------------------------------------------------------
{
    // MARK: - IBOutlets
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var portraitView                                 : UIImageView!
    @IBOutlet weak var nameLabel                                    : UILabel!
    @IBOutlet weak var addressLabel                                 : UILabel!
    @IBOutlet weak var favorLabel                                   : UILabel!
    @IBOutlet weak var rewardLabel                                  : UILabel!
    @IBOutlet weak var priceLabel                                   : UILabel!
    @IBOutlet weak var audioView                                    : UIView!
    @IBOutlet weak var imageScrollView                              : UIScrollView!
    @IBOutlet weak var pageControl                                  : UIPageControl!
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var profileCell                                  : UITableViewCell!
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var plus1Button                                  : UIButton!
    @IBOutlet weak var plus5Button                                  : UIButton!
    @IBOutlet weak var plus10Button                                 : UIButton!
    @IBOutlet weak var clearButton                                  : UIButton!
    //----------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Variables
    //----------------------------------------------------------------------------------------------------------
    var favor : PFObject!
    private var didLayoutSubviews                                   = false
    var defaultPrice: String?
    var audioAsset                                                  = AVURLAsset()
    var playerView                                                  = SYWaveformPlayerView()
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
        configAudio()
        configAudioView()
        //configImages()
        //configImageView()
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func viewDidAppear(animated: Bool)
    //----------------------------------------------------------------------------------------------------------
    {
        super.viewDidAppear(true)
        tableView.reloadData()
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
        file.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil {
                self.portraitView.image = UIImage(data: data!)!
            }
        })
    
        self.nameLabel.text = user[Constants.User.Nickname] as? String
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
                            self.configImageView()
                        }
                    }
                })
            }
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configLooks() {
        tableView.backgroundColor = Constants.Color.TableBackgroundColor
    }

    //----------------------------------------------------------------------------------------------------------
    func configDefaults()
    //----------------------------------------------------------------------------------------------------------
    {
        defaultPrice =  priceLabel.text
    }
    
    //----------------------------------------------------------------------------------------------------------
    func configShape()
    //----------------------------------------------------------------------------------------------------------
    {
        portraitView.image                                          = portraitView.image?.rounded
        portraitView.layer.borderColor                              = UIColor.whiteColor().CGColor
        portraitView.layer.borderWidth                              = 1
        portraitView.layer.cornerRadius                             = portraitView.layer.frame.height/2

        plus1Button.layer.borderColor                               = UIColor.lightGrayColor().CGColor
        plus1Button.layer.borderWidth                               = 0.3
        plus1Button.layer.cornerRadius                              = plus1Button.layer.frame.height/2
        
        plus5Button.layer.borderColor                               = UIColor.lightGrayColor().CGColor
        plus5Button.layer.borderWidth                               = 0.3
        plus5Button.layer.cornerRadius                              = plus5Button.layer.frame.height/2
        
        plus10Button.layer.borderColor                              = UIColor.lightGrayColor().CGColor
        plus10Button.layer.borderWidth                              = 0.3
        plus10Button.layer.cornerRadius                             = plus10Button.layer.frame.height/2
        
        clearButton.layer.borderColor                               = UIColor.lightGrayColor().CGColor
        clearButton.layer.borderWidth                               = 0.3
        clearButton.layer.cornerRadius                              = clearButton.layer.frame.height/2
        
        reshapeImageView()
        reshapeAudioView()
    }
    
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
        playerView = SYWaveformPlayerView(frame: audioView.frame, asset: audioAsset, color: Constants.Color.AudioViewColor, progressColor: Constants.Color.AudioViewProgressColor)
        audioView.addSubview(playerView)
    }
    
    //----------------------------------------------------------------------------------------------------------
    func reshapeAudioView()
    //----------------------------------------------------------------------------------------------------------
    {
        playerView.frame = audioView.frame
    }
    
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
        let scrollViewWidth: CGFloat = imageScrollView.frame.width
        let scrollViewHeight: CGFloat = imageScrollView.frame.height
        
        for (index, element) in enumerate(images) {
            var imageView = UIImageView(image: element)
            imageView.frame = CGRectMake(scrollViewWidth*CGFloat(index), 0, scrollViewWidth, scrollViewHeight)
            imageView.userInteractionEnabled = true
            imageViews.append(imageView)
            imageScrollView.addSubview(imageView)
        }
        
        imageScrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(images.count), scrollViewHeight)
        imageScrollView.delegate = self
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
    }
    
    //----------------------------------------------------------------------------------------------------------
    func reshapeImageView()
    //----------------------------------------------------------------------------------------------------------
    {
        let scrollViewWidth: CGFloat = imageScrollView.frame.width
        let scrollViewHeight: CGFloat = imageScrollView.frame.height
        
        for (index, element) in enumerate(imageViews) {
            element.frame = CGRectMake(scrollViewWidth*CGFloat(index), 0, scrollViewWidth, scrollViewHeight)
        }
        
        imageScrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(images.count), scrollViewHeight)
    }
    
    
    // MARK: - Delegations
    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //----------------------------------------------------------------------------------------------------------
    {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return calculateHeightForString(addressLabel.text!) + 50
        case 2:
            return calculateHeightForString(favorLabel.text!) + 50
        case 3:
            return calculateHeightForString(rewardLabel.text!) + 50
        case 4:
            return 60
        case 5:
            if indexPath.row == 1 {
                return 250
            } else {
                return 44
            }
        default:
            return 44
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    //----------------------------------------------------------------------------------------------------------
    {
        var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.backgroundColor = Constants.Color.CellBackgroundColor
        if indexPath.section != 0 {
            if indexPath.row == 0 {
                cell.addTopBorderWithHeight(0.5, color: Constants.Color.GlobalTintColor)
            }
        }
        return cell
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    //----------------------------------------------------------------------------------------------------------
    {
        // Test the offset and calculate the current page after scrolling ends
        var pageWidth: CGFloat = CGRectGetWidth(scrollView.frame)
        var currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        pageControl.currentPage = Int(currentPage)
        
        // center on content
        var newContentOffsetX = (CGFloat(pageControl.currentPage)) * scrollView.frame.width
        imageScrollView.contentOffset = CGPointMake(newContentOffsetX, 0)
    }
    
}










