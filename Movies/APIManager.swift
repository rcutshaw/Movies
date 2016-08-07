//
//  APIManager.swift
//  Movies
//
//  Created by David Cutshaw on 7/30/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import Foundation

class APIManager {
    
    func loadData(urlString: String, completion: [XMovies] -> ()) {  // step 2 and step 7
        
        // Get a non-cached session
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        // Create a url and kick off an asynchronous task
        let url = NSURL(string: urlString)!
        
        let task = session.dataTaskWithURL(url) {  // does its work on a different queue from main
            
            (data, response, error) -> () in  // get our 3 responses - data, response and error
            
            // if error, move everything back to main queue - step 5
            if error != nil {
                
                print(error!.localizedDescription)
                    
            } else {
                
                // Add JSONSerialization
                do {
                    /* .AllowFragments - top level object is not Array or Dictionary.
                     Any type of string or value.
                     NSJSONSerialization requires the Do / Try / Catch.
                     Converts the NSDATA into a JSON object and casts it to a Dictionary. */
                    
                    // step 3
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? JSONDictionary,
                                feed = json["feed"] as? JSONDictionary,
                                entries = feed["entry"] as? JSONArray {
                        
                        var movies = [XMovies]()
                        for (index, entry) in entries.enumerate() {
                            let entry = XMovies(data: entry as! JSONDictionary)
                            entry.mRank = index + 1
                            movies.append(entry)
                        }
                        
                        
                        let i = movies.count
                        print("iTunesApiManager - total count --> \(i)")  // step 5
                        
                        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT  // step 6
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(movies)
                            }
                        }
                    }
                } catch {
                     print("error in NSJSONSerialization")
                }
                // End of JSONSerialization
            }
        }
        task.resume()  // starts the task - step 4
    }
}