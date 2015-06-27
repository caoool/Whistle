//
//  FavorDetailTable.swift
//  Whistle
//
//  Created by Lu Cao on 6/24/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class FavorDetailTable: UITableViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var portraitView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var favorLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var didLayoutSubviews = false
    
    var defaultPrice: String?
    var audioAsset = AVURLAsset()
    var playerView = SYWaveformPlayerView()
    var images = [UIImage]()
    var imageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configDefaults()
        configAudio()
        configAudioView()
        configImages()
        configImageView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        configShape()
    }

    func configDefaults() {
        defaultPrice =  priceLabel.text
    }
    
    func configShape() {
        portraitView.image = portraitView.image?.rounded
        reshapeImageView()
        reshapeAudioView()
    }
    
    func configAudio() {
        audioAsset = AVURLAsset(URL: NSBundle.mainBundle().URLForResource("test audio", withExtension: "mp3"), options: nil)
    }
    
    func configAudioView() {
        playerView = SYWaveformPlayerView(frame: audioView.frame, asset: audioAsset, color: Constants.Color.AudioViewColor, progressColor: Constants.Color.AudioViewProgressColor)
        audioView.addSubview(playerView)
    }
    
    func reshapeAudioView() {
        playerView.frame = audioView.frame
    }
    
    func configImages() {
        images.append(UIImage(named: "Portrait_Test")!)
        images.append(UIImage(named: "finished_indicator_favor")!)
        images.append(UIImage(named: "Portrait_Test")!)
    }
    
    func configImageView() {
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
    
    func reshapeImageView() {
        let scrollViewWidth: CGFloat = imageScrollView.frame.width
        let scrollViewHeight: CGFloat = imageScrollView.frame.height
        
        for (index, element) in enumerate(imageViews) {
            element.frame = CGRectMake(scrollViewWidth*CGFloat(index), 0, scrollViewWidth, scrollViewHeight)
        }
        
        imageScrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(images.count), scrollViewHeight)
    }
    
    @IBAction func modifyPrice(sender: UIButton) {
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        switch indexPath.section {
        case 0:
            return 50
        case 1:
            return calculateHeightForString(addressLabel.text!) + 70
        case 2:
            return calculateHeightForString(favorLabel.text!) + 70
        case 3:
            return calculateHeightForString(rewardLabel.text!) + 70
        case 6:
            if indexPath.row == 1 {
                return 250
            } else {
                return 44
            }
        default:
            return 44
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        
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










