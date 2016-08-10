//
//  Movie.swift
//  Movies
//
//  Created by David Cutshaw on 7/31/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import Foundation

class XMovie { // This was originally named 'Movies'.  Had to rename it 'XMovies' to avoid a conflict in an Apple SDK.
                // When it was 'Movies', I got a console error on line in APIManager.swift at "var movies = [XMovies]()".
                // The error was --> expression produced error: /var/folders/6c/yckqgz_11dn67j50jfz2zczh0000gn/T/lldb/6276/expr21.swift:1:65: error:
                // 'Movies' is not a member type of 'Movies' $__lldb__DumpForDebugger(Swift.UnsafePointer<Swift.Array<Movies.Movies>>(bitPattern:
                // 0x102fd04a0).memory) ~~~~~~ ^ /var/folders/6c/yckqgz_11dn67j50jfz2zczh0000gn/T/lldb/6276/expr19.swift:1:45: note: while parsing
                // this '<' as a type parameter bracket $__lldb__DumpForDebugger(Swift.UnsafePointer<Swift.Array<Movies.Movies>>(bitPattern:
                // 0x102fd04a0).memory)

    // Data Encapsulation
    private(set) var mRank:Int
    private(set) var mName:String
    private(set) var mRights:String
    private(set) var mPrice:String
    private(set) var mImageUrl:String
    private(set) var mArtist:String
    private(set) var mMovieUrl:String
    private(set) var mImid:String
    private(set) var mGenre:String
    private(set) var mLinkToiTunes:String
    private(set) var mReleaseDate:String
    
    // This variable gets created from the UI
    var mImageData:NSData?
    
    init(mRank:Int, mName:String, mRights:String, mPrice:String,                // step 3
        mImageUrl:String, mArtist:String, mMovieUrl:String, mImid:String,
        mGenre:String, mLinkToiTunes:String, mReleaseDate:String) {
        
        
        self.mRank = mRank
        self.mName = mName
        self.mRights = mRights
        self.mPrice = mPrice
        self.mImageUrl = mImageUrl
        self.mArtist = mArtist
        self.mMovieUrl = mMovieUrl
        self.mImid = mImid
        self.mGenre = mGenre
        self.mLinkToiTunes = mLinkToiTunes
        self.mReleaseDate = mReleaseDate
        
    }
}