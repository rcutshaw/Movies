//
//  AboutVC.swift
//  Movies
//
//  Created by David Cutshaw on 8/4/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var alwaysKnow: UILabel!
    @IBOutlet weak var preview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
    }
    
    func preferredFontChanged() {
        alwaysKnow.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        preview.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
    
}
