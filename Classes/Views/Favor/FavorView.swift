//
//  FavorView.swift
//  Whistle
//
//  Created by Lu Cao on 6/24/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import MapKit

class FavorView: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var foldButton: UIButton!
    
    private var isFolded = false
    private var detailViewOriginalFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidLayoutSubviews() {
        configDefaults()
        configShapes()
    }
    
    func configDefaults() {
        detailViewOriginalFrame = detailView.frame
    }

    func configShapes() {
        mapView.roundCorners(.TopLeft | .TopRight, radius: Constants.Radius.CornerBig)
    }

    @IBAction func foldButtonPressed(sender: AnyObject) {
        if !isFolded {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                var yDif = self.detailView.layer.frame.origin.y - self.foldButton.layer.frame.origin.y
                self.detailView.frame = self.view.frame
                self.foldButton.layer.frame.origin.y = self.detailView.layer.frame.origin.y - yDif
                }, completion: {
                    (finished: Bool) -> Void in
                    self.isFolded = !self.isFolded
            })
        } else {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                var yDif = self.detailView.layer.frame.origin.y - self.foldButton.layer.frame.origin.y
                self.detailView.frame = self.detailViewOriginalFrame!
                self.foldButton.layer.frame.origin.y = self.detailView.layer.frame.origin.y - yDif
                }, completion: {
                    (finished: Bool) -> Void in
                    self.isFolded = !self.isFolded
            })
        }
        
    }
    
}
