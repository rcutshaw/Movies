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
            
            // if error, move everything back to main queue - step 5
            if error != nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    completion(result: (error!.localizedDescription))  // move error into result - step 6 alternate
                }
                    
            } else {
                
                // Add JSONSerialization
                do {
                    /* .AllowFragments - top level object is not Array or Dictionary.
                     Any type of string or value.
                     NSJSONSerialization requires the Do / Try / Catch.
                     Converts the NSDATA into a JSON object and casts it to a Dictionary. */
                    
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!,  // step 6 alternate
                                                            options: .AllowFragments)
                                                            as? [String: AnyObject] {
                        print(json)  // step 7
                        
                        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(result: "JSONSerialization Successful")  // step 8
                            }
                        }
                    }
                } catch {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(result: "error in NSJSONSerialization")
                    }
                }
                // End of JSONSerialization
            }
        }
        task.resume()  // starts the task - step 4
    }
}