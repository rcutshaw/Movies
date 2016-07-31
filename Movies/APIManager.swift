//
//  APIManager.swift
//  Movies
//
//  Created by David Cutshaw on 7/30/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import Foundation

class APIManager {
    
    func loadData(urlString: String, completion: (result: String) -> ()) {  // result: String is input to another method
        
        // Get a non-cached session
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        // Create a url and kick off an asynchronous task
        let url = NSURL(string: urlString)!
        
        let task = session.dataTaskWithURL(url) {  // does its work on a different queue from main - step 3
            
            (data, response, error) -> () in  // get our 3 responses - data, response and error
            
            // move everything back to main queue
            dispatch_async(dispatch_get_main_queue()) {  // step 5
                
                if error != nil {  // step 6
                    
                    completion(result: (error!.localizedDescription))  // move error into result - // step 7
                    
                } else {
                    
                    completion(result: "NSURLSession successful")  // move successful string into result - // step 7
                    print(data)  // step 9
                    
                }
            }
        }
        task.resume()  // starts the task - step 4
    }
}