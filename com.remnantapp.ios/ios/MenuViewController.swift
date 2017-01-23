//
//  MenuViewController.swift
//  Taasky
//
//  Created by Audrey M Tam on 18/03/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuItemCell: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    
    var customNavigationBar: UIView?
    var container:MenuContainerViewController?
    
    lazy var menuItems: NSArray = {
        let path = NSBundle.mainBundle().pathForResource("MenuItems", ofType: "plist")
        return NSArray(contentsOfFile: path!)!
        }()
    
    
    var startupViewController:StartupViewController? {
        didSet {
            customNavigationBar = startupViewController?.customNavigationBar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        // Remove the drop shadow from the navigation bar
        //navigationController!.navigationBar.clipsToBounds = true
        //startupViewController!.menuItem = (menuItems[0] as! NSDictionary)
    }
    
    // MARK: - Segues
    
    
    
    // MARK: - Table View
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let menuItem = menuItems[indexPath.row] as! NSDictionary
        
        
        startupViewController!.menuItem = menuItem
        container?.hideOrShowMenu(false, animated: false)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // adjust row height so items all fit into view
        let divisor = customNavigationBar != nil ? customNavigationBar!.bounds.height : 50
        
        let rectHeight = CGRectGetHeight(self.view.bounds) - 20
        let numItems = CGFloat(menuItems.count)
        let height = (rectHeight / numItems)
        return max(80, height)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell") as! MenuItemCell
        let menuItem = menuItems[indexPath.row] as! NSDictionary
        cell.configureForMenuItem(menuItem)
        return cell
    }
    
}
