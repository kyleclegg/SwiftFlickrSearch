//
//  SearchResult.swift
//  FlickrSearch
//
//  Created by Kyle Clegg on 12/09/14.
//  Copyright (c) 2014 Kyle Clegg. All rights reserved.
//

import Foundation
import UIKit

struct FlickrPhoto {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
    
}
