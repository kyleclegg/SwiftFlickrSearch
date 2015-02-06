//
//  FlickrAPI.swift
//  FlickrSearch
//
//  Created by Kyle Clegg on 12/10/14.
//  Copyright (c) 2014 Kyle Clegg. All rights reserved.
//

import Foundation

class FlickrProvider {

    typealias FlickrResponse = (NSError?, [FlickrPhoto]?) -> Void
    
    struct Keys {
        static let flickrKey = "0461b2b85aee5a025189ce3eed1aff6b"
    }
    
    struct Errors {
        static let invalidAccessErrorCode = 100
    }
    
    class func fetchPhotosForSearchText(searchText: String, onCompletion: FlickrResponse) -> Void {
        
        let escapedSearchText: String = searchText.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Keys.flickrKey)&tags=\(escapedSearchText)&per_page=25&format=json&nojsoncallback=1"
        let url: NSURL = NSURL(string: urlString)!
        let searchTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                println("Error fetching photos: \(error)")
                onCompletion(error, nil)
                return
            }
            
            var jsonError: NSError?
            var resultsDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
            if jsonError != nil {
                println("Error parsing JSON: \(jsonError!)")
                onCompletion(jsonError, nil)
                return
            }
            
            if let statusCode = resultsDictionary!["code"] as? Int {
                if statusCode == Errors.invalidAccessErrorCode {
                    let invalidAccessError = NSError(domain: "com.flickr.api", code: statusCode, userInfo: nil)
                    onCompletion(invalidAccessError, nil)
                    return
                }
            }
            
            let photosContainer = resultsDictionary!["photos"] as NSDictionary
            let photosArray = photosContainer["photo"] as [NSDictionary]
            
            let flickrPhotos: [FlickrPhoto] = photosArray.map {
                photoDictionary in
                
                let photoId = photoDictionary["id"] as? String ?? ""
                let farm = photoDictionary["farm"] as? Int ?? 0
                let secret = photoDictionary["secret"] as? String ?? ""
                let server = photoDictionary["server"] as? String ?? ""
                let title = photoDictionary["title"] as? String ?? ""
                
                let flickrPhoto = FlickrPhoto(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                return flickrPhoto
            }
            
            onCompletion(nil, flickrPhotos)
        })
        searchTask.resume()
    }
    
}
