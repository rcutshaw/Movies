//
//  CustomImageView.swift
//  Movies
//
//  Created by David Cutshaw on 8/19/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import UIKit

let imageCache = NSCache()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String, movie: XMovie) {
        let url = NSURL(string: urlString)
        
        imageUrlString = urlString
        
        self.image = nil
        
        if let imageFromCache = imageCache.objectForKey(urlString) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            movie.mImageData = data!
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let imageToCache = UIImage(data: data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString)
                
            })
            
        }).resume()
    }
    
}
