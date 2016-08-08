//
//  Movie.swift
//  Movies
//
//  Created by David Cutshaw on 7/31/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import Foundation

class XMovies { // This was originally named 'Movies'.  Had to rename it 'XMovies' to avoid a conflict in an Apple SDK.
                // When it was 'Movies', I got a console error on line in APIManager.swift at "var movies = [XMovies]()".
                // The error was --> expression produced error: /var/folders/6c/yckqgz_11dn67j50jfz2zczh0000gn/T/lldb/6276/expr21.swift:1:65: error:
                // 'Movies' is not a member type of 'Movies' $__lldb__DumpForDebugger(Swift.UnsafePointer<Swift.Array<Movies.Movies>>(bitPattern:
                // 0x102fd04a0).memory) ~~~~~~ ^ /var/folders/6c/yckqgz_11dn67j50jfz2zczh0000gn/T/lldb/6276/expr19.swift:1:45: note: while parsing
                // this '<' as a type parameter bracket $__lldb__DumpForDebugger(Swift.UnsafePointer<Swift.Array<Movies.Movies>>(bitPattern:
                // 0x102fd04a0).memory)

    var mRank = 0
    
    // Data Encapsulation
    private var _mName:String
    private var _mRights:String
    private var _mPrice:String
    private var _mSummary:String
    private var _mRentalPrice:String
    private var _mImageUrl:String
    private var _mArtist:String
    private var _mMovieUrl:String
    private var _mImid:String
    private var _mGenre:String
    private var _mLinkToiTunes:String
    private var _mReleaseDate:String
    
    // This variable gets created from the UI
    var mImageData:NSData?
    
    // Make getters
    
    var mName: String {
        return _mName
    }
    
    var mRights: String {
        return _mRights
    }
    
    var mPrice: String {
        return _mPrice
    }
    
    var mSummary: String {
        return _mSummary
    }

    var mImageUrl: String {
        return _mImageUrl
    }
    
    var mArtist: String {
        return _mArtist
    }
    
    var mMovieUrl: String {
        return _mMovieUrl
    }
    
    var mImid: String {
        return _mImid
    }
    
    var mGenre: String {
        return _mGenre
    }
    var mLinkToiTunes: String {
        return _mLinkToiTunes
    }
    
    var mReleaseDate: String {
        return _mReleaseDate
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
        
        // Movie Rights
        if let rights = data["rights"] as? JSONDictionary,
            mRights = rights["label"] as? String {
            self._mRights = mRights
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mRights = ""
        }
        
        // Movie Price
        if let price = data["im:price"] as? JSONDictionary,
            mPrice = price["label"] as? String {
            self._mPrice = mPrice
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mPrice = ""
        }
        
        // Movie summary
        if let summary = data["im:name"] as? JSONDictionary,
            mSummary = summary["label"] as? String {
            self._mSummary = mSummary
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mSummary = ""
        }
        
        // Movie rental price
        if let rPrice = data["im:name"] as? JSONDictionary,
            mRentalPrice = rPrice["label"] as? String {
            self._mRentalPrice = mRentalPrice
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mRentalPrice = ""
        }
        
        // The Movie Image
        if let img = data["im:image"] as? JSONArray,
            image = img[2] as? JSONDictionary,
            mImageUrl = image["label"] as? String {
            if NSUserDefaults.standardUserDefaults().boolForKey("BestImageQualSetting") == true && reachabilityStatus == WIFI {
                _mImageUrl = mImageUrl.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
            } else {
                _mImageUrl = mImageUrl.stringByReplacingOccurrencesOfString("100x100", withString: "300x300")
            }
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mImageUrl = ""
        }
        
        // The Artist
        if let artist = data["im:artist"] as? JSONDictionary,
            mArtist = artist["label"] as? String {
            self._mArtist = mArtist
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mArtist = ""
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
        
        // Movie Imid
        if let imid = data["id"] as? JSONDictionary,
            vid = imid["attributes"] as? JSONDictionary,
            mImid = vid["im:id"] as? String {
            self._mImid = mImid
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mImid = ""
        }
        
        // Movie Genre
        if let genre = data["category"] as? JSONDictionary,
            ggenre = genre["attributes"] as? JSONDictionary,
            mGenre = ggenre["term"] as? String {
            self._mGenre = mGenre
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mGenre = ""
        }
        
        // Movie Link to iTunes
        if let ltoitunes = data["link"] as? JSONArray,
            link1 = ltoitunes[1] as? JSONDictionary,
            vRef = link1["attributes"] as? JSONDictionary,
            mLinkToiTunes = vRef["href"] as? String {
            self._mLinkToiTunes = mLinkToiTunes
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mLinkToiTunes = ""
        }
        
        // Movie Release date
        if let release = data["im:releaseDate"] as? JSONDictionary,
            date = release["attributes"] as? JSONDictionary,
            mReleaseDate = date["label"] as? String {
            self._mReleaseDate = mReleaseDate
        } else {
            // You may not always get data back from the JSON - you may want to display message
            // Element in the JSON is unexpected
            
            _mReleaseDate = ""
        }
    }
}