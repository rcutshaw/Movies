//
//  Movies.swift
//  Movies
//
//  Created by David Cutshaw on 7/31/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import Foundation

class Movies {
    
    // Data Encapsulation
    
    private var _mName:String
    private var _mImageUrl:String
    private var _mMovieUrl:String
    
    // Make getters
    
    var mName: String {
        return _mName
    }
    
    var mImageUrl: String {
        return _mImageUrl
    }
    
    var mMovieUrl: String {
        return _mMovieUrl
    }
    
    init(data: JSONDictionary) {
        
        // If we do not inialize all properties, we will get error message
        // Return from inializer without initializing all stored properties
        
        // Movie name
        if let name = data["im:name"] as? JSONDictionary,
            mName = name["label"] as? String {
            self._mName = mName
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mName = ""
        }
        
        // The Movie Image
        if let img = data["im:image"] as? JSONArray,
            image = img[2] as? JSONDictionary,
            immage = image["label"] as? String {
            _mImageUrl = immage.stringByReplacingOccurrencesOfString("170x170", withString: "600x600")
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mImageUrl = ""
        }
        
        // Movie Url
        if let movie = data["link"] as? JSONArray,
            mUrl = movie[1] as? JSONDictionary,
            mHref = mUrl["attributes"] as? JSONDictionary,
            mMovieUrl = mHref["href"] as? String {
            self._mMovieUrl = mMovieUrl
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mMovieUrl = ""
        }
        
    }
    
    
}