//
//  APIManager.swift
//  Movies
//
//  Created by David Cutshaw on 7/30/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import Foundation

class APIManager {
    
    func loadData(urlString: String, completion: [XMovie] -> ()) {  // step 2 and step 7
        
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
                
                let videos = self.parseJson(data)
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(videos)
                    }
                }
            }
        }
        
        task.resume()  // starts the task - step 4
    }
    
    func parseJson(data: NSData?) -> [XMovie] {
        
        do {
            
            if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as AnyObject? {
                
                return JsonDataExtractor.extractVideoDataFromJson(json)
            }
            
        } catch {
            
            print("Failed to parse data: \(error)")
            
        }
        
        return [XMovie]()
    }
}