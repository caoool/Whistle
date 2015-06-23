////
////  ViewController.swift
////  ParseStarterProject
////
////  Created by Yetian Mao on 6/7/15.
////  Copyright (c) 2015 Parse. All rights reserved.
////
//
//import UIKit
//import Parse
//
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
//    
//    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var messageTableView: UITableView!
//    @IBOutlet weak var sendButton: UIButton!
//    @IBOutlet weak var messageTextField: UITextField!
//    
//    var messagesArray : [String] = [String]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        self.messageTableView.delegate = self
//        self.messageTableView.dataSource = self
//        self.messageTextField.delegate = self
//        
//        // Add a tap gesture recognizer to the tableview
//        
//        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
//        self.messageTableView.addGestureRecognizer(tapGesture)
//        
//        // Retrieve messages from Parse
//        self.retrieveMessages()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    @IBAction func sendButtonTapped(sender: AnyObject) {
//        // Send Button is Tapped
//        
//        // Call the end editing method for the text field
//        self.messageTextField.endEditing(true)
//        
//        // Disable the send button and textfield
//        self.messageTextField.enabled = false
//        self.sendButton.enabled = false
//        
//        // Create a PFObject
//        var newMessageObject : PFObject = PFObject(className: "Message")
//        
//        // Set the Text key to the text of the messageTextField
//        newMessageObject["Text"] = self.messageTextField.text
//        
//        // Save the PFObject
//        newMessageObject.saveInBackgroundWithBlock { (success : Bool, error : NSError?) -> Void in
//            if (success) {
//                // Message has been saved
//                // Retrieve from Parse and update table
//                self.retrieveMessages()
//                println("Message saved successfully")
//                
//            } else {
//                // Something bad happened
//                println(error!.description)
//            }
//            
//            dispatch_async(dispatch_get_main_queue()){
//                self.sendButton.enabled = true
//                self.messageTextField.enabled = true
//                self.messageTextField.text = ""
//            }
//            
//        }
//        
//        
//    }
//    
//    func retrieveMessages() {
//        // Create a new PFQuery
//        var query : PFQuery = PFQuery(className: "Message")
//        
//        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//            // Clear the messageArray
//            self.messagesArray = [String]()
//            // Loop through the objects array
//            for object in objects! {
//                // Retrieve the Text column value of each PFObject
//                let messageText : String? = (object as! PFObject)["Text"] as? String
//                
//                // Assign it into our messagesArray
//                if messageText != nil {
//                    self.messagesArray.append(messageText!)
//                }
//            }
//            dispatch_async(dispatch_get_main_queue()){
//                // Reload the table View
//                self.messageTableView.reloadData()
//            }
//        }
//    }
//    
//    func tableViewTapped() {
//        // Force the textfield to end editing
//        
//        self.messageTextField.endEditing(true)
//    }
//    
//    // MARK: TextFieldView Delegate Methods
//    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        // Perform an animation to grow the dockview
//        self.view.layoutIfNeeded()
//        UIView.animateWithDuration(0.5, animations: {
//            self.dockViewHeightConstraint.constant = 350
//            self.view.layoutIfNeeded()
//            }, completion: nil)
//    }
//    
//    func textFieldDidEndEditing(textField: UITextField) {
//        // Perform an animation to lower the dockview
//        
//        self.view.layoutIfNeeded()
//        UIView.animateWithDuration(0.5, animations: {
//            self.dockViewHeightConstraint.constant = 60
//            self.view.layoutIfNeeded()
//            }, completion: nil)
//    }
//    
//    // MARK: TableView Delegate Methods
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        // Create a table Cell
//        let cell = self.messageTableView.dequeueReusableCellWithIdentifier("MessageCell") as! UITableViewCell
//        // Customize the Cell
//        cell.textLabel?.text = self.messagesArray[indexPath.row]
//        // Return the Cell
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messagesArray.count
//    }
//    
//}
//
