//
//  FavorDetailTable.swift
//  Whistle
//
//  Created by Lu Cao on 6/24/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class FavorDetailTable: UITableViewController {

    @IBOutlet weak var portraitView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favorLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var defaultPrice: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configDefaults()
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
            return calculateHeightForString(favorLabel.text!) + 70
        case 2:
            return calculateHeightForString(rewardLabel.text!) + 70
        default:
            return 44
        }
    }
    
    
    
}
