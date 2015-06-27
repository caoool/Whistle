//
//  ProfileView.swift
//  Whistle
//
//  Created by Lu Cao on 6/24/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class ProfileView: UIViewController {
    
    private var o = false

    // MARK: - IBOutlets
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var portraitView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lineLabel: UILabel!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var favorsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorConfig()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        

    }
    
    override func viewDidLayoutSubviews() {
        
        shapeConfig()
    }
    
    func colorConfig() {
        infoView.backgroundColor = Constants.Color.Test
        nameLabel.textColor = Constants.Color.TextLight
        lineLabel.textColor = Constants.Color.TextLight
        likesLabel.textColor = Constants.Color.TextLight
        favorsLabel.textColor = Constants.Color.TextLight
    }
    
    func shapeConfig() {
        infoView.roundCorners(UIRectCorner.TopLeft | UIRectCorner.TopRight, radius: Constants.Radius.CornerBig)
        portraitView.image = portraitView.image?.rounded
        
        var borderView: UIView = UIView(frame: CGRectMake(0, 0, portraitView.layer.frame.width, portraitView.layer.frame.height))
        borderView.center = portraitView.center
        borderView.layer.borderColor = UIColor.blueColor().CGColor
        borderView.layer.borderWidth = 5
        borderView.layer.cornerRadius = borderView.layer.frame.height/2
        infoView.addSubview(borderView)
    }
    
}
