//
//  AddLocationVC.swift
//  Whistle
//
//  Created by Lu Cao on 5/3/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

class AddAddressView: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var streetLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var stateLabel: UITextField!
    @IBOutlet weak var postLabel: UITextField!
    @IBOutlet weak var countryLabel: UITextField!
    
    
    // for search location
    private var latitude: Double?
    private var longitude: Double?
    
    private var searchController: UISearchController!
    private var annotation: MKAnnotation!
    private var localSearchRequest: MKLocalSearchRequest!
    private var localSearch: MKLocalSearch!
    private var localSearchResponse: MKLocalSearchResponse!
    private var error: NSError!
    private var pointAnnotation: MKPointAnnotation!
    private var pinAnnotationView: MKPinAnnotationView!
    
    // for user location
    var manager: CLLocationManager!
    var myLocations: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUIWithUserLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        navigationController?.navigationBar.topItem!.title = ""
        
        myView.layer.borderWidth = 0.3
        myView.layer.borderColor = UIColor.lightGrayColor().CGColor
        myView.layer.cornerRadius = 12
        
        
    }
    
    // MARK: - Functionalities
    
    func updateUIWithUserLocation() {
        
        mapView.delegate = self
        
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
            
            let latitude = manager.location.coordinate.latitude
            let longitude = manager.location.coordinate.longitude
            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
            
            var locationManager = LocationManager.sharedInstance
            locationManager.reverseGeocodeLocationWithLatLon(latitude: latitude, longitude: longitude) { (reverseGecodeInfo,placemark,error) -> Void in
                
                if(error != nil) {
                    
                    println(error)
                } else {
                    
                    println(reverseGecodeInfo!)
                    let address = reverseGecodeInfo!["formattedAddress"] as! String
                    var splitAddress = address.componentsSeparatedByString(", ")
                    let country = reverseGecodeInfo!["country"] as? String
                    let post = reverseGecodeInfo!["postalCode"] as? String
                    let state = reverseGecodeInfo!["administrativeArea"] as? String
                    let city = reverseGecodeInfo!["locality"] as? String
                    for i in 1...3 {
                        if splitAddress.count > 1 {
                            splitAddress.removeLast()
                        }
                    }
                    let joiner = ", "
                    let street = joiner.join(splitAddress)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        // do ui updates here
                        
                        self.streetLabel.text = street
                        self.cityLabel.text = city
                        self.stateLabel.text = state
                        self.postLabel.text = post
                        self.countryLabel.text = country
                    }
                }
                
            }
        }
        
    }
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0] as! MKAnnotation
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil {
                var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
            
            self.latitude = localSearchResponse.boundingRegion.center.latitude
            self.longitude = localSearchResponse.boundingRegion.center.longitude
            
            self.pointAnnotation = CustomPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            //            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            
            
            let center = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(self.pinAnnotationView.annotation)
            
            var locationManager = LocationManager.sharedInstance
            locationManager.reverseGeocodeLocationWithLatLon(latitude: self.latitude!, longitude: self.longitude!) { (reverseGecodeInfo,placemark,error) -> Void in
                
                if(error != nil) {
                    
                    println(error)
                } else {
                    
                    println(reverseGecodeInfo!)
                    let address = reverseGecodeInfo!["formattedAddress"] as! String
                    var splitAddress = address.componentsSeparatedByString(", ")
                    let country = reverseGecodeInfo!["country"] as! String
                    let post = reverseGecodeInfo!["postalCode"] as! String
                    let state = reverseGecodeInfo!["administrativeArea"] as! String
                    let city = reverseGecodeInfo!["locality"] as! String
                    splitAddress.removeLast()
                    splitAddress.removeLast()
                    splitAddress.removeLast()
                    let joiner = ", "
                    let street = joiner.join(splitAddress)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        // do ui updates here
                        
                        self.streetLabel.text = street
                        self.cityLabel.text = city
                        self.stateLabel.text = state
                        self.postLabel.text = post
                        self.countryLabel.text = country
                    }
                }
                
            }
        }
    }
    
    @IBAction func addAddress(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Delegates
    
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
        anView.image = UIImage(named: "map pin.png")
        
        return anView
    }
    
}
