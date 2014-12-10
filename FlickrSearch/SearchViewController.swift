//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Kyle Clegg on 12/10/14.
//  Copyright (c) 2014 Kyle Clegg. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? SearchResultCell
        
        cell!.resultTitleLabel.text = "hey"
        
        return cell!
    }
}

