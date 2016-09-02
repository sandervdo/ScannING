//
//  MenuTableViewController.swift
//  ScannING
//
//  Created by Victor Li on 23-03-16.
//  Copyright © 2016 ScannING. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCellWithIdentifier("header")!
        }
        if indexPath.row == 1 {
            return tableView.dequeueReusableCellWithIdentifier("menu1")!
        }
        return tableView.dequeueReusableCellWithIdentifier("menu2")!
    }
}
