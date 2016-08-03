//
//  SettingsTVC.swift
//  Movies
//
//  Created by David Cutshaw on 8/2/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

    @IBOutlet weak var aboutDisplay: UILabel!
    @IBOutlet weak var feedbackDisplay: UILabel!
    @IBOutlet weak var securityDisplay: UILabel!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var bestImageDisplay: UILabel!
    @IBOutlet weak var APICnt: UILabel!
    @IBOutlet weak var sliderCnt: UISlider!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        tableView.alwaysBounceVertical = false
        title = "Settings"
        
        touchID.on = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
    }
    
    @IBAction func touchIdSec(sender: UISwitch) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if touchID.on {
            defaults.setBool(touchID.on, forKey: "SecSetting")
        } else {
            defaults.setBool(false, forKey: "SecSetting")
        }
    }
    
    func preferredFontChanged() {
        
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        APICnt.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
    }
    
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

}
