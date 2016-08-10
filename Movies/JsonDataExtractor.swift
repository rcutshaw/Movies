//
//  JsonDataExtractor.swift
//  Movies
//
//  Created by David Cutshaw on 8/10/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import Foundation

class JsonDataExtractor {
    
    static func extractVideoDataFromJson(movieDataObject: AnyObject) -> [XMovie] {
        
        guard let movieData = movieDataObject as? JSONDictionary else { return [XMovie]() }
        
        var movies = [XMovie]()
        
        if let feeds = movieData["feed"] as? JSONDictionary, entries = feeds["entry"] as? JSONArray {
            
            for (index, data) in entries.enumerate() {
                
                var mName = " ", mRights = "", mPrice = "", mImageUrl = "",
                mArtist = "", mMovieUrl = "", mImid = "", mGenre = "",
                mLinkToiTunes = "", mReleaseDate = ""
                
                // Video Name
                if let imName = data["im:name"] as? JSONDictionary,
                    label = imName["label"] as? String {
                    mName = label
                }
                
                // Video Rights
                if let rights = data["rights"] as? JSONDictionary,
                    label = rights["label"] as? String {
                    mRights = label
                }
                
                // Video Price
                if let imPrice = data["im:price"] as? JSONDictionary,
                    label = imPrice["label"] as? String {
                    mPrice = label
                }
                
                // The Video Image
                if let imImage = data["im:image"] as? JSONArray,
                    image = imImage[2] as? JSONDictionary,
                    label = image["label"] as? String {
                    
                    mImageUrl = label.stringByReplacingOccurrencesOfString("100x100", withString: "300x300")
                    if NSUserDefaults.standardUserDefaults().boolForKey("BestImageQualSetting") == true && reachabilityStatus == WIFI {
                        mImageUrl = label.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
                        
                    }
                }
                
                // The Artist
                if let imArtist = data["im:artist"] as? JSONDictionary,
                    label = imArtist["label"] as? String {
                    mArtist = label
                }
                
                // Video Url
                if let link = data["link"] as? JSONArray,
                    link1 = link[1] as? JSONDictionary,
                    attributes = link1["attributes"] as? JSONDictionary,
                    href = attributes["href"] as? String {
                    mMovieUrl = href
                }
                
                // Imid
                if let id = data["id"] as? JSONDictionary,
                    attributes = id["attributes"] as? JSONDictionary,
                    imId = attributes["im:id"] as? String {
                    mImid = imId
                }
                
                // Genre
                if let category = data["category"] as? JSONDictionary,
                    attributes = category["attributes"] as? JSONDictionary,
                    term = attributes["term"] as? String {
                    mGenre = term
                }
                
                // Link to iTunes
                if let link = data["link"] as? JSONArray,
                    link1 = link[1] as? JSONDictionary,
                    attributes = link1["attributes"] as? JSONDictionary,
                    href = attributes["href"] as? String {
                    mLinkToiTunes = href
                }
                
                // Release date
                if let imRelease = data["im:releaseDate"] as? JSONDictionary,
                    attributes = imRelease["attributes"] as? JSONDictionary,
                    label = attributes["label"] as? String {
                    mReleaseDate = label
                }
                
                let currentMovie = XMovie(mRank: index + 1, mName: mName, mRights: mRights, mPrice: mPrice, mImageUrl: mImageUrl, mArtist: mArtist, mMovieUrl: mMovieUrl, mImid: mImid, mGenre: mGenre, mLinkToiTunes: mLinkToiTunes, mReleaseDate: mReleaseDate)
                
                movies.append(currentMovie)
                
            }
            
        }
        
        return movies
        
    }
}
