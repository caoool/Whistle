//
//  ProfileRegionPickerView.swift
//  Whistle
//
//  Created by Lu Cao on 6/29/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//

import UIKit

class ProfileRegionPickerView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var states = ["Alabama", "Alaska", "California", "Colorado", "Florida"]
    var citys = [
        ["Alabama1", "Alabama2", "Alabama3", "Alabama4", "Alabama5"],
        ["Alaska1", "Alaska2", "Alaska3", "Alaska4", "Alaska5"],
        ["California1", "California2", "California3", "California4", "California5"],
        ["Colorado1", "Colorado2", "Colorado3", "Colorado4", "Colorado5"],
        ["Florida1", "Florida2", "Florida3", "Florida4", "Florida5"]
    ]
    
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var myPickerView: UIPickerView!
    
    private var selectedState: Int = 0
    private var selectedCity: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var button = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action:"submit")
        self.navigationItem.rightBarButtonItem = button

        myPickerView.dataSource = self
        myPickerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submit() {
        navigationController?.popViewControllerAnimated(true)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return states.count
        case 1:
            return citys[selectedState].count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch component {
        case 0:
            return states[row]
        case 1:
            return citys[selectedState][row]
        default:
            return "nil"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedState = row
            pickerView.reloadComponent(1)
        case 1:
            selectedCity = row
        default:
            return
        }
        regionLabel.text = "\(citys[selectedState][selectedCity]), \(states[selectedState])"
    }

}
