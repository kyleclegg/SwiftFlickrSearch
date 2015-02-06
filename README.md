SwiftFlickrSearch
============

This application is an example of searching the Flickr API for photos in Swift. Notably, it uses a UISearchDisplayController and the async callback pattern. See [http://kyleclegg.com/blog/swift-flickr-search](http://kyleclegg.com/blog/swift-flickr-search).

![Search Screen](https://dl.dropboxusercontent.com/u/7354353/flickrsearch/f2.png) ![Photo Screen](https://dl.dropboxusercontent.com/u/7354353/flickrsearch/f3.png)

### Getting Started

- Clone the repo and run FlickrSearch.xcodeproj
- No pod install or carthage update needed -- the only external library, SDWebImage, has been added to the project directly

### The Flickr API

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

We use the farm, server, id, and secret to build the image path.
- Image Path: http://farmFARM.staticflickr.com/SERVER/ID_SECRET_m.jpg
- Example: http://farm8.staticflickr.com/7564/15981410640_a0d5006167_m.jpg
- Response object is the image file

### Other Notes

- More details available at [Swift Flickr Search](http://kyleclegg.com/blog/swift-flickr-search)
- If you plan to build on this or use it a lot, I recommend replacing the Flickr API key with your own
- Async pallback pattern in Swift credit goes to [@szehnder](https://gist.github.com/szehnder/84b0bd6f45a7f3f99306)



