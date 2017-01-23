//
//  ResultsTableView.swift
//  ios
//
//  Created by System Administrator on 11/6/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit
import Parse

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SocialSearchResultsDelegate {

    var baseTableView:UITableView?
    var searchResults = [NSDictionary]()
    
    func setTableViewOnSuperClass(tableViewFromChild:UITableView){
        baseTableView = tableViewFromChild
        
        let nib = UINib(nibName: "ResultsViewCell", bundle: nil)
        baseTableView!.registerNib(nib, forCellReuseIdentifier: "searchResultsCell")
        baseTableView!.delegate = self
        baseTableView!.dataSource = self
        baseTableView!.tableFooterView = UIView(frame: CGRectZero)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultsCell") as? ResultsViewCell
        
        
        cell!.loadFromPFObject(searchResults[indexPath.row])
        cell!.socialSearchResultsDelegate = self
        
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var numOfSection: NSInteger = 0
        
        if searchResults.count > 0 {
            
            self.baseTableView!.backgroundView = nil
            numOfSection = 1
            
            
        } else {
            
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.baseTableView!.bounds.size.width, self.baseTableView!.bounds.size.height))
            noDataLabel.text = "No results found"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.Center
            self.baseTableView!.backgroundView = noDataLabel
            
        }
        return numOfSection
    }
    
    func followButtonTapped(userToFollow: PFUser, cell:ResultsViewCell) {
        let xself = self
        SpinnerUtility.startAnimatingForView(self.view)
        DataAccessLayer.followUser(userToFollow).then { (activity:PFObject?) -> Void in
            cell.followActivity = activity
            cell.followButton.setTitle("unfollow", forState: UIControlState.Normal)
            SpinnerUtility.stopAnimatingForView(self.view)
            }.error() { error in
                UIUtility.ShowAlert(xself, title: "Error", message: "There was a problem")
                SpinnerUtility.stopAnimatingForView(xself.view)
        }
    }
    
    func unfollowButtonTapped(userToFollow: PFUser, followActivity:PFObject, cell:ResultsViewCell) {
        let xself = self
        SpinnerUtility.startAnimatingForView(self.view)
        DataAccessLayer.unfollowUser(followActivity).then{ (success:Bool) -> Void in
            if(success == true){
                cell.followButton.setTitle("follow", forState: UIControlState.Normal)
            }
            SpinnerUtility.stopAnimatingForView(self.view)
            
            }.error() { error in
                UIUtility.ShowAlert(xself, title: "Error", message: "There was a problem")
                SpinnerUtility.stopAnimatingForView(xself.view)
        }
        
    }
    
}
