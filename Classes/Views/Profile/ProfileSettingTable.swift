//
//  ProfileSettingTable.swift
//  Whistle
//
//  Created by Lu Cao on 7/11/15.
//  Copyright (c) 2015 LoopCow. All rights reserved.
//


//----------------------------------------------------------------------------------------------------------
import UIKit
//----------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------
class ProfileSettingTable: UITableViewController
//----------------------------------------------------------------------------------------------------------
{
    // MARK: - IBOutlets
    //----------------------------------------------------------------------------------------------------------
    // Profile Edit
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var editIcon                         : UIImageView!
    @IBOutlet weak var editLine                         : UIView!
    @IBOutlet weak var editHeader                       : UILabel!
    @IBOutlet weak var portrait                         : UIImageView!
    @IBOutlet weak var id                               : UILabel!
    //----------------------------------------------------------------------------------------------------------
    // Account
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var accountIcon                      : UIImageView!
    @IBOutlet weak var accountLine                      : UIView!
    @IBOutlet weak var accountHeader                    : UILabel!
    @IBOutlet weak var phoneLabel                       : UILabel!
    @IBOutlet weak var phoneKeyLabel                    : UILabel!
    @IBOutlet weak var emailLabel                       : UILabel!
    @IBOutlet weak var emailKeyLabel                    : UILabel!
    @IBOutlet weak var facebookLabel                    : UILabel!
    @IBOutlet weak var facebookKeyLabel                 : UILabel!
    @IBOutlet weak var accountDot                       : UIView!
    @IBOutlet weak var twitterLabel                     : UILabel!
    @IBOutlet weak var twitterKeyLabel                  : UILabel!
    //----------------------------------------------------------------------------------------------------------
    // Privacy
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var privacyIcon                      : UIImageView!
    @IBOutlet weak var privacyLine                      : UIView!
    @IBOutlet weak var privacyHeader                    : UILabel!
    @IBOutlet weak var friendConfLabel                  : UILabel!
    @IBOutlet weak var friendConfSwitch                 : UISwitch!
    @IBOutlet weak var publicLabel                      : UILabel!
    @IBOutlet weak var publicSwitch                     : UISwitch!
    @IBOutlet weak var blockListLabel                   : UILabel!
    //----------------------------------------------------------------------------------------------------------
    // Notification
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var notifyIcon                       : UIImageView!
    @IBOutlet weak var notifyLine                       : UIView!
    @IBOutlet weak var notifyHeader                     : UILabel!
    @IBOutlet weak var notifyDot                        : UIView!
    @IBOutlet weak var whistleNotifyLabel               : UILabel!
    @IBOutlet weak var whistleNofitySwitch              : UISwitch!
    @IBOutlet weak var chatNotifyLabel                  : UILabel!
    @IBOutlet weak var chatNotifySwitch                 : UISwitch!
    //----------------------------------------------------------------------------------------------------------
    // Logout
    //----------------------------------------------------------------------------------------------------------
    @IBOutlet weak var logoutButton                     : UIButton!
    //----------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Initializations
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    //----------------------------------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        configLooks()
    }

    //----------------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning()
    //----------------------------------------------------------------------------------------------------------
    {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Functions
    //----------------------------------------------------------------------------------------------------------
    func configLooks()
    //----------------------------------------------------------------------------------------------------------
    {
        tableView.backgroundColor                       = Constants.Color.TableBackground
        
        var iconList = [editIcon, accountIcon, privacyIcon, notifyIcon]
        for element in iconList {
            element.layer.borderColor                   = Constants.Color.Border.CGColor
            element.layer.borderWidth                   = 2
            element.layer.cornerRadius                  = 16
            element.backgroundColor                     = Constants.Color.Border
            
            let origImage                               = element.image
            let tintedImage                             = origImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            element.image                               = tintedImage
            element.tintColor                           =  Constants.Color.TableBackground
        }
        
        var lineList = [editLine, accountLine, privacyLine, notifyLine]
        for element in lineList {
            element.backgroundColor                     = Constants.Color.Border
        }
        
        var dotList = [accountDot, notifyDot]
        for element in dotList {
            element.backgroundColor                     = Constants.Color.Border
            element.layer.cornerRadius                  = 6
        }
        
        var headerList = [editHeader, accountHeader, privacyHeader, notifyHeader]
        for element in headerList {
            element.textColor                           = Constants.Color.PlaceHolder
        }
        
        var labelList = [phoneLabel, emailLabel, facebookLabel, facebookKeyLabel, twitterLabel, twitterKeyLabel, friendConfLabel, publicLabel, blockListLabel, whistleNotifyLabel, chatNotifyLabel]
        for element in labelList {
            element.textColor                           = Constants.Color.CellText
            element.shadowColor                         = Constants.Color.CellTextShadow
            element.shadowOffset                        = CGSizeMake(0, -1)
        }
        
        var keyLabelList = [id, phoneKeyLabel, emailKeyLabel]
        for element in keyLabelList {
            element.textColor                           = Constants.Color.CellText
            element.layer.cornerRadius                  = 6
            element.backgroundColor                     = Constants.Color.ContentBackground
        }
        
        var switchList = [friendConfSwitch, publicSwitch, whistleNofitySwitch, chatNotifySwitch]
        for element in switchList {
            element.layer.anchorPoint                   = CGPointMake(0.3, 0.5)
            element.transform                           = CGAffineTransformMakeScale(0.75, 0.75)
        }
            
        portrait.layer.borderColor                      = Constants.Color.Border.CGColor
        portrait.layer.borderWidth                      = 2
        portrait.layer.cornerRadius                     = 30
        portrait.backgroundColor                        = Constants.Color.Border
        
        logoutButton.setTitleColor(Constants.Color.CellText, forState: .Normal)
        logoutButton.layer.backgroundColor              = Constants.Color.ContentBackground.CGColor
        logoutButton.layer.cornerRadius                 = 15
    }

    // MARK: - Delegates
    //----------------------------------------------------------------------------------------------------------
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    //----------------------------------------------------------------------------------------------------------
    {
        return 1
    }
    
    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    //----------------------------------------------------------------------------------------------------------
    {
        return 5
    }

    //----------------------------------------------------------------------------------------------------------
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    //----------------------------------------------------------------------------------------------------------
    {
        var cell                = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.backgroundColor    = Constants.Color.Background
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
