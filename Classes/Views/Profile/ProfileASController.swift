//
//  ContentViewController.swift
//  SheetAlertExample
//
//  Created by Kyohei Ito on 2015/01/09.
//  Copyright (c) 2015年 kyohei_ito. All rights reserved.
//


//----------------------------------------------------------------------------------------------------------
import UIKit
//----------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------
class ProfileASController: UIViewController
//----------------------------------------------------------------------------------------------------------
{
    // MARK: - IBOutlets
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var portrait                         : UIImageView!
    @IBOutlet weak var nameLabel                        : UILabel!
    @IBOutlet weak var lineLabel                        : UILabel!
    //----------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Init
    //----------------------------------------------------------------------------------------------------------
    init()
    //----------------------------------------------------------------------------------------------------------
    {
        super.init(nibName: "ProfileASController", bundle: nil)
    }
    
    //----------------------------------------------------------------------------------------------------------
    required init(coder aDecoder: NSCoder)
    //----------------------------------------------------------------------------------------------------------
    {
        super.init(coder: aDecoder)
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    //----------------------------------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        portrait.layer.cornerRadius                     = 60
    }
    
}