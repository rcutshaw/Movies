//
//  MovieDetailVC.swift
//  Movies
//
//  Created by David Cutshaw on 8/1/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

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

    @IBAction func socialMedia(sender: UIBarButtonItem) {
        
        shareMedia()
    }
    
    func shareMedia() {
        
        let activity1 = "Have you had the opportunity to see this Movie?"
        let activity2 = ("\(movies.mName) by \(movies.mArtist)")
        let activity3 = "Watch it and tell me what you think?"
        let activity4 = movies.mLinkToiTunes
        let activity5 = "(Shared with the Movie App - Step It UP!)"
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity3, activity4,activity5], applicationActivities: nil)
        
        //activityViewController.excludedActivityTypes =  [UIActivityTypeMail]
        
        
        
        //        activityViewController.excludedActivityTypes =  [
        //            UIActivityTypePostToTwitter,
        //            UIActivityTypePostToFacebook,
        //            UIActivityTypePostToWeibo,
        //            UIActivityTypeMessage,
        //            UIActivityTypeMail,
        //            UIActivityTypePrint,
        //            UIActivityTypeCopyToPasteboard,
        //            UIActivityTypeAssignToContact,
        //            UIActivityTypeSaveToCameraRoll,
        //            UIActivityTypeAddToReadingList,
        //            UIActivityTypePostToFlickr,
        //            UIActivityTypePostToVimeo,
        //            UIActivityTypePostToTencentWeibo
        //        ]
        
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if activity == UIActivityTypeMail {
                print ("email selected")
            }
            
        }
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        
        let url = NSURL(string: movies.mMovieUrl)!
        let player = AVPlayer(URL: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true ) {
            playerViewController.player?.play()
        }
    }
    
    // Is called just as the object is about to be deallocated
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
}
