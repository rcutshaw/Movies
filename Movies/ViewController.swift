//
//  ViewController.swift
//  Movies
//
//  Created by David Cutshaw on 7/30/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var movies = [Movies]()  // created this array to hold all our fetched movies
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        
        reachabilityStatusChanged()
        
        let api = APIManager()
        
        //        api.loadData("https://itunes.apple.com/us/rss/topmovies/limit=10/genre=4401/json") {
        //            (result:String) in
        //            print(result)
        //        }

        api.loadData("https://itunes.apple.com/us/rss/topmovies/limit=50/genre=4401/json",  // step 1
            completion: didLoadData)  // when done, executes didLoadData  // step 2
    }

    func didLoadData(movies: [Movies]) {  // result from APIManager method is now the input to didLoadData - step 8
        
        print(reachabilityStatus)
        
        self.movies = movies  // stored in class instance
        
        for item in movies {
            print("name = \(item.mName)")
        }
        
        // Best
        for (index, item) in movies.enumerate() {
            print("\(index) name = \(item.mName)")
        }
        
        tableView.reloadData()
        
        // Better
        //        for i in 0..<videos.count {
        //            let video = videos[i]
        //            print("\(i) name = \(video.vName)")
        //        }
        
        // Not good - old style
        //        for var i = 0; i < videos.count; i++ {
        //            let video = videos[i]
        //            print("\(i) name = \(video.vName)")
        //        }
    }
    
    func reachabilityStatusChanged()
    {
        
        switch reachabilityStatus {
            
        case NOACCESS : view.backgroundColor = UIColor.redColor()
        displayLabel.text = "No Internet"
        case WIFI : view.backgroundColor = UIColor.greenColor()
        displayLabel.text = "Reachable with WIFI"
        case WWAN : view.backgroundColor = UIColor.yellowColor()
        displayLabel.text = "Reachable with Cellular"
        default:return
            
        }
        
    }
    
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let movie = movies[indexPath.row]
        
        cell.textLabel?.text = ("\(indexPath.row + 1)" )
        
        cell.detailTextLabel?.text = movie.mName
        
        return cell
    }
}

