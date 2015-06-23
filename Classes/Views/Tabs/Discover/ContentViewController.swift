//
//  ContentViewController.swift
//  Arrived
//
//  Created by Lu Cao on 5/31/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import MapKit

class ContentViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var toPass: String?
    var latitude: Double?
    var longitude: Double?
    
    private var pointAnnotation: MKPointAnnotation!
    private var pinAnnotationView: MKPinAnnotationView!
    
    init() {
        super.init(nibName: "ContentViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = toPass!
        addressLabel.layer.frame = CGRectMake(mapView.frame.width/2, 0, addressLabel.layer.frame.width, addressLabel.layer.frame.height)
        addressLabel.layer.backgroundColor = UIColorFromHex(0xFFFFFF, alpha: 0.65).CGColor
        addressLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        addressLabel.layer.borderWidth = 1.2
        addressLabel.layer.cornerRadius = 5
        
        mapView.delegate = self
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        var annotation = CustomPointAnnotation()
        annotation.coordinate = location
        annotation.imageName = "regular pin"
        mapView.addAnnotation(annotation)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Customize annotation appearance
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
