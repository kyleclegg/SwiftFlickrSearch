FlickrSearch
============

This project showcases several fundamental iOS programming tasks in Swift. The app hits the Flickr API to perform a search and display images. It is meant to be a clean example of working with a REST API and JSON in Swift, and demonstrates using asychronous callbacks to simplify networking requests and eliminate messy view controllers.

### Technologies Used

- Swift
- FlickrAPI
- UISearchDisplayController and UISearchBar
- Asychronous Callback Pattern
- JSON Parsing
- SDWebImage

### Getting Started

- Clone the repo and run FlickrSearch.xcodeproj
- No pod install or carthage update needed -- the only external library, SDWebImage, has been added to the project directly

### Working with the Flickr API

Images are retrieved by hitting the [Flickr API](https://www.flickr.com/services/api/flickr.photos.search.html). 
- Search Path: https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=FLICKR_API_KEY&tags=SEARCH_TEXT&per_page=25&format=json&nojsoncallback=1
- Response includes an array of photo objects, each represented as: 
``` swift
{
    "farm": 8,
    "id": 15981410640,
    "isfamily": 0,
    "isfriend": 0,
    "ispublic": 1,
    "owner": "28339853@N03",
    "secret": "a0d5006167",
    "server": 7564,
    "title": "Chi shark week"
}
```

We will use the farm, server, id, and secret to build the image path.
- Image Path: http://farmFARM.staticflickr.com/SERVER/ID_SECRET_m.jpg
- Example: http://farm8.staticflickr.com/7564/15981410640_a0d5006167_m.jpg
- Response object is the image file

### Parsing JSON in Swift

``` swift
var jsonError: NSError?
var resultsDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
if jsonError != nil {
  println("Error parsing JSON: \(jsonError!)")
}
println("results: \(resultsDictionary)")
```

### Asychronous Callback Pattern

Rather than putting the networking code in the view controller it is separated into a data provider class. This class uses a callback to send the appropriate data back to the view controller for display.

Data Provider:
``` swift
class FlickrProvider {

  typealias FlickrResponse = (NSError?, [FlickrPhoto]?) -> Void
    
  struct Keys {
    static let flickrKey = "0461b2b85aee5a025189ce3eed1aff6b"
  }
    
  class func fetchPhotosForSearchText(searchText: String, onCompletion: FlickrResponse) -> Void {
    let escapedSearchText: String = searchText.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Keys.flickrKey)&tags=\(escapedSearchText)&per_page=25&format=json&nojsoncallback=1"
    let url: NSURL = NSURL(string: urlString)!
    let searchTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
      
      if error != nil {
        println("Error fetching photos: \(error)")
        onCompletion(error, nil)
      }

      var jsonError: NSError?
      var resultsDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
      if jsonError != nil {
        println("Error parsing JSON: \(jsonError!)")
        onCompletion(jsonError, nil)
      }
      
      if let statusCode = resultsDictionary!["code"] as? Int {
        if statusCode == 100 {
          let invalidAccessError = NSError(domain: "com.flickr.api", code: statusCode, userInfo: nil)
          onCompletion(invalidAccessError, nil)
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
```

View Controller:
``` swift
FlickrProvider.fetchPhotosForSearchText(searchText, onCompletion: { (error: NSError?, flickrPhotos: [FlickrPhoto]?) -> Void in
  if error == nil {
    self.photos = flickrPhotos!
  } else {
    self.photos = []
  }
  dispatch_async(dispatch_get_main_queue(), { () -> Void in
    self.tableView.reloadData()
  })
})
```

### Other Notes

- If you plan to build on this or use it a lot, I recommend replacing the Flickr API key with your own
- Async pallback pattern in Swift credit goes to [@szehnder](https://gist.github.com/szehnder/84b0bd6f45a7f3f99306)



