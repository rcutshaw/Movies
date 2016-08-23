//
//  MovieTVC.swift
//  Movies
//
//  Created by David Cutshaw on 7/31/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import UIKit

class MovieTVC: UITableViewController/*, UISearchResultsUpdating*/ {

    var movies = [XMovie]()  // created this array to hold all our fetched movies
    var filterSearch = [XMovie]()
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    var limit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if swift(>=2.2)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(bestImageQualityChanged), name: "BestImageQualityChanged", object: nil)
            
        #else
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChanged", name: UIContentSizeCategoryDidChangeNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "bestImageQualityChanged", name: "BestImageQualityChanged", object: nil)
            
        #endif
        
        // I want to use the best image quality the first time the app gets launched after a fresh installation,
        // before user defaults have been set - this won't get called thereafter and will rely on values set in
        // user defaults by UI switches.
        if !NSUserDefaults.standardUserDefaults().boolForKey("isNotFirstLaunch") {
            //Set autoAdjustSettings and isNotFirstLaunch to true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "BestImageQualSetting")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isNotFirstLaunch")
            
            //Sync NSUserDefaults
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        reachabilityStatusChanged()
        
    }
    
    func preferredFontChanged() {
        
        print("The preferred Font has changed")
    }
    
    func didLoadData(movies: [XMovie]) {  // result from APIManager method is now the input to didLoadData - step 8
        
        print(reachabilityStatus)
        
        self.movies = movies  // stored in class instance
        
        for (index, item) in movies.enumerate() {
            print("\(index) title = \(item.mName) - artist = \(item.mArtist)")
            
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        
        title = ("The iTunes Top \(limit) Movies")
        
        // Setup the Search Controller
        
        resultSearchController.searchResultsUpdater = self
        
        definesPresentationContext = true
        
        resultSearchController.dimsBackgroundDuringPresentation = false
        
        resultSearchController.searchBar.placeholder = "Search for Artist, Name, Rank"
        
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        
        resultSearchController.searchBar.sizeToFit()  // For some reason, need to call this so that search bar shows up on iPad 2 with iOS 8.4
        // Evidently, the search bar frame is set to CGRectZero if not called here.
        // add the search bar to your tableview
        
        tableView.tableHeaderView = resultSearchController.searchBar
        
        tableView.reloadData()
    }
    
    func reachabilityStatusChanged()
    {
        
        switch reachabilityStatus {
            
        case NOACCESS :
            //view.backgroundColor = UIColor.redColor()
            // Move back to main queue because viewDidLoad hasn't finished and no view on screen yet, so get the
            // console Warning message "Presenting view controllers on detached view controllers is discouraged"
            // Dispatching to main queue fixes this because it asynchronously runs this code, giving view time to appear first
            dispatch_async(dispatch_get_main_queue()) {
                let alert = UIAlertController(title: "No Internet Access", message: "Please make sure you are connected to the Internet", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {
                    action -> () in
                    print("Cancel")
                }
                
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) {
                    action -> () in
                    print("Delete")
                }
                
                let okAction = UIAlertAction(title: "Ok", style: .Default) {
                    action -> () in
                    print("Ok")
                    
                    // do something if you want
                    //alert.dismissViewControllerAnimated(true, completion: nil)
                }
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        default:
            //view.backgroundColor = UIColor.greenColor()
            if movies.count > 0 {
                print("do not refresh API")
            } else {
                runAPI()
            }
        }
    }
    
    func bestImageQualityChanged() {
        
        runAPI()
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        
        refreshControl?.endRefreshing()
        if resultSearchController.active {
            refreshControl?.attributedTitle = NSAttributedString(string: "No refresh allowed in search")
        } else {
            runAPI()
        }
        
    }
    
    func getAPICount() {
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil) {
            
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            limit = theValue
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDte = formatter.stringFromDate(NSDate())
        
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDte)")
        
    }
    
    func runAPI() {
        
        getAPICount()
        
        // Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmovies/limit=\(limit)/genre=4401/json",
                     completion: didLoadData)  // when done, executes didLoadData
        
    }
    
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "BestImageQualityChanged", object: nil)
        print("MTVC deinit called")
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.active {
            return filterSearch.count
        } else {
            return movies.count
        }
    }

    private struct storyboard {
        static let cellReuseIdentifier = "cell"
        static let segueIdentifier = "movieDetail"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! MovieTableViewCell
        
        if resultSearchController.active {
            cell.movie = filterSearch[indexPath.row]
        } else {
            cell.movie = movies[indexPath.row]
        }
        
//        print("indexPath = \(indexPath.row)", "movies[\(indexPath.row)] = \(movies[indexPath.row].mName)")
            
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == storyboard.segueIdentifier {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let movie: XMovie
                if resultSearchController.active {
                    movie = filterSearch[indexPath.row]
                } else {
                    movie = movies[indexPath.row]
                }
                let dvc = segue.destinationViewController as! MovieDetailVC
                dvc.movies = movie
            }
        }
    }
    
    //    func updateSearchResultsForSearchController(searchController: UISearchController) {
    //        searchController.searchBar.text!.lowercaseString
    //        filterSearch(searchController.searchBar.text!)
    //    }
    
    
    func filterSearch(searchText: String) {
        filterSearch = movies.filter { movies in
            return movies.mArtist.lowercaseString.containsString(searchText.lowercaseString) ||
                movies.mName.lowercaseString.containsString(searchText.lowercaseString) || "\(movies.mRank)".lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
}

// If you want, you can add this extension and remove the protocol from the class definition and
// remove the func updateSearchResultsForSearchController from this file
// Another way is to not put the extension in this file here, but create a separate file and put
// all your extensions, including this one in that file.  Your choice!
//extension MovieTVC: UISearchResultsUpdating {
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        searchController.searchBar.text!.lowercaseString
//        filterSearch(searchController.searchBar.text!)
//    }
//}
