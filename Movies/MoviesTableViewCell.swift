//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by David Cutshaw on 7/31/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    var movie: XMovies? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    func updateCell() {
        
        movieTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        rank.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        movieTitle.text = movie?.mName
        rank.text = ("\(movie!.mRank)")
        //movieImage.image = UIImage(named: "imageNotAvailable")
        
        if movie!.mImageData != nil {
            print("Get data from array ...")
            movieImage.image = UIImage(data: movie!.mImageData!)
        } else {
            print("Get data from internet ...")
            GetMovieImage(movie!, imageView: movieImage)
        }
    }

    func GetMovieImage(movie: XMovies, imageView : UIImageView){
        
        // Background thread
        //  DISPATCH_QUEUE_PRIORITY_HIGH Items dispatched to the queue will run at high priority, i.e. the queue will be scheduled for execution before any default priority or low priority queue.
        //
        //  DISPATCH_QUEUE_PRIORITY_DEFAULT Items dispatched to the queue will run at the default priority, i.e. the queue will be scheduled for execution after all high priority queues have been scheduled, but before any low priority queues have been scheduled.
        //
        //  DISPATCH_QUEUE_PRIORITY_LOW Items dispatched to the queue will run at low priority, i.e. the queue will be scheduled for execution after all default priority and high priority queues have been scheduled.
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let data = NSData(contentsOfURL: NSURL(string: movie.mImageUrl)!)
            
            var image : UIImage?
            if data != nil {
                movie.mImageData = data
                image = UIImage(data: data!)
            }
            
            // move back to Main Queue
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
        }
    }
}
