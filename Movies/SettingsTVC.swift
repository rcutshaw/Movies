//
//  SettingsTVC.swift
//  Movies
//
//  Created by David Cutshaw on 8/2/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import UIKit
import MessageUI
import LocalAuthentication

class SettingsTVC: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var aboutDisplay: UILabel!
    @IBOutlet weak var feedbackDisplay: UILabel!
    @IBOutlet weak var securityDisplay: UILabel!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var bestImageDisplay: UILabel!
    @IBOutlet weak var APICnt: UILabel!
    @IBOutlet weak var sliderCnt: UISlider!
    @IBOutlet weak var numberOfVideos: UILabel!
    @IBOutlet weak var dragSliderLabel: UILabel!
    @IBOutlet weak var securityCheckLabel: UILabel!
    @IBOutlet weak var bestQualitySwitch: UISwitch!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        #if swift(>=2.2)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
            
        #else
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChanged", name: UIContentSizeCategoryDidChangeNotification, object: nil)
            
        #endif
        
        tableView.alwaysBounceVertical = false
        title = "Settings"
        
        touchID.on = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
        
        // Create the Local Authentication Context
        let context = LAContext()
        var touchIDError : NSError?
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:&touchIDError) {
            self.securityCheckLabel.hidden = true
        } else {
            self.securityCheckLabel.hidden = false
            self.touchID.enabled = false
        }
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil) {
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            APICnt.text = "\(theValue)"
            sliderCnt.value = Float(theValue)
        } else {
            sliderCnt.value = 10.0
            APICnt.text = ("\(Int(sliderCnt.value))")
        }
    }
    
    @IBAction func valueChanged(sender: UISlider) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Int(sliderCnt.value), forKey: "APICNT")
        APICnt.text = ("\(Int(sliderCnt.value))")
    }
    
    @IBAction func touchIdSec(sender: UISwitch) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if touchID.on {
            defaults.setBool(touchID.on, forKey: "SecSetting")
        } else {
            defaults.setBool(false, forKey: "SecSetting")
        }
    }
    
    @IBAction func bestImageQual(sender: UISwitch) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if bestQualitySwitch.on == true {
            defaults.setBool(bestQualitySwitch.on, forKey: "BestImageQualSetting")
        } else {
            defaults.setBool(false, forKey: "BestImageQualSetting")
        }
        NSNotificationCenter.defaultCenter().postNotificationName("BestImageQualityChanged", object: nil)
    }
    
    func preferredFontChanged() {
        
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        APICnt.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        numberOfVideos.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        dragSliderLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            let mailComposeViewController = configureMail()
            
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController,  animated: true, completion: nil)
            }
            else
            {
                // No email account Setup on Phone
                mailAlert()
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }
    
    func configureMail() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["rcutshaw@icloud.com"])
        mailComposeVC.setSubject("Movie App Feedback")
        mailComposeVC.setMessageBody("Hi Randy,\n\nI would like to share the following feedback...\n", isHTML: false)
        return mailComposeVC
    }
    
    func mailAlert() {
        
        let alertController: UIAlertController = UIAlertController(title: "Alert", message: "No e-Mail Account setup for Phone", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            //do something if you want
        }
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail Failed")
        default:
            print("Unknown Issue")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

}
