//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Kyle Clegg on 12/09/14.
//  Copyright (c) 2014 Kyle Clegg. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var photos: [FlickrPhoto] = []
    
    // MARK: - Actions
    
    @IBAction func resetSearch(sender: AnyObject) {
        photos.removeAll(keepingCapacity: false);
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
        self.title = "Flickr Search"
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResultCellIdentifier = "SearchResultCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: searchResultCellIdentifier, for: indexPath as IndexPath) as? SearchResultCell
        cell!.setupWithPhoto(flickrPhoto: photos[indexPath.row])
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PhotoSegue", sender: self)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        performSearchWithText(searchText: searchBar.text!)
    }
    
    // MARK - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoSegue" {
            let photoViewController = segue.destination as! PhotoViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            photoViewController.flickrPhoto = photos[selectedIndexPath!.row]
        }
        
    }
    
    // MARK: - Private
    
    private func performSearchWithText(searchText: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        FlickrProvider.fetchPhotosForSearchText(searchText: searchText, onCompletion: { (error: NSError?, flickrPhotos: [FlickrPhoto]?) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil {
                self.photos = flickrPhotos!
            } else {
                self.photos = []
                if (error!.code == FlickrProvider.Errors.invalidAccessErrorCode) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.showErrorAlert()
                    })
                }
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.title = searchText
                self.tableView.reloadData()
            })
        })
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Search Error", message: "Invalid API Key", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
