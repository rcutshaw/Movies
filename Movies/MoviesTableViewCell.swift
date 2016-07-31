//
//  MoviesTableViewCell.swift
//  Movies
//
//  Created by David Cutshaw on 7/31/16.
//  Copyright © 2016 Bit Smartz LLC. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    var movie: Movies? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    func updateCell() {
        movieTitle.text = movie?.mName
        rank.text = ("\(movie!.mRank)")
        movieImage.image = UIImage(named: "imageNotAvailable")
    }

}
