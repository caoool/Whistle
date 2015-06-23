//
//  UserLocationsTVCell.swift
//  Whistle
//
//  Created by Lu Cao on 5/3/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import MapKit

class AddressCell: UITableViewCell {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var defaultIndicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myView.layer.borderWidth = 0.3
        myView.layer.borderColor = UIColor.lightGrayColor().CGColor
        myView.layer.cornerRadius = 12
        
        defaultIndicator.layer.backgroundColor = UIColorFromHex(0x3ABE68, alpha: 0.65).CGColor
        defaultIndicator.alpha = 0
    }
    
}
