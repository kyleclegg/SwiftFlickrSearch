//
//  SearchResultCell.swift
//  FlickrSearch
//
//  Created by Kyle Clegg on 12/09/14.
//  Copyright (c) 2014 Kyle Clegg. All rights reserved.
//

import Foundation
import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    
    func setupWithPhoto(flickrPhoto: FlickrPhoto) {
        resultTitleLabel.text = flickrPhoto.title
        resultImageView.sd_setImage(with: flickrPhoto.photoUrl as URL!)
    }
    
}
