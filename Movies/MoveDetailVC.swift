//
//  MovieDetailVC.swift
//  Movies
//
//  Created by David Cutshaw on 8/1/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import UIKit

class MovieDetailVC: UIViewController {

    var movies: XMovies!
    
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mMovieImage: UIImageView!
    @IBOutlet weak var mGenre: UILabel!
    @IBOutlet weak var mPrice: UILabel!
    @IBOutlet weak var mRights: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        title = movies.mArtist
        mName.text = movies.mName
        mPrice.text = movies.mPrice
        mRights.text = movies.mRights
        mGenre.text = movies.mGenre
        
        if movies.mImageData != nil {
            mMovieImage.image = UIImage(data: movies.mImageData!)
        } else {
            mMovieImage.image = UIImage(named: "imageNotAvailable")
        }
    }
    
    func preferredFontChanged() {
        
        mName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        mGenre.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        mPrice.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        mRights.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }

    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
}
