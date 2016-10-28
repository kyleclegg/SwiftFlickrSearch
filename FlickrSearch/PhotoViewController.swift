//
//  PhotoViewController.swift
//  FlickrSearch
//
//  Created by Kyle Clegg on 12/10/14.
//  Copyright (c) 2014 Kyle Clegg. All rights reserved.
//

import Foundation

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var flickrPhoto: FlickrPhoto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if flickrPhoto != nil {
            photoImageView.sd_setImage(with: flickrPhoto!.photoUrl as URL!)
        }
    }
    
}
