//
//  EditStatusView.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/14/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class EditStatusView: UITableViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Status"
        self.textView.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.topItem!.title = ""
    }
    
    let COMMENTS_LIMIT = 10
    
    func textViewDidChange(textView: UITextView) {
        
        let temp = textView.text as NSString
        
        if count(textView.text) > 10 {
            textView.text = temp.substringToIndex(temp.length - 1)
        }
    }
    
   
    
}
