//
//  ViewController.swift
//  Movies
//
//  Created by David Cutshaw on 7/30/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmovies/limit=10/genre=4401/json",  // step 1
            completion: didLoadData)  // when done, executes didLoadData  // step 2
    }

    func didLoadData(result:String) {  // result from APIManager method is now the input to didLoadData
        
        print(result)  // step 9
        
        let alert = UIAlertController(title: (result), message: nil, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            // do something if you want
        }
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

