//
//  FollowingViewController.swift
//  ios
//
//  Created by System Administrator on 11/2/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit
import Parse

class FollowingViewController: ResultsViewController, SocialContainerChildViewController {
    
    var container:SocialFollowersViewController?
    
    @IBOutlet weak var resultsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.setTableViewOnSuperClass(resultsTable)
        self.resultsTable.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        SpinnerUtility.initializeSpinnerInViewDidAppear(self.view)
        SpinnerUtility.startAnimatingForView(self.view)
        DataAccessLayer.getUsersFollowedByCurrentUser().then{ (activities: [PFObject]?) -> Void in
            
            var arrayOfResults = [NSDictionary]()
            
            for activity in activities!{
                let dict:NSDictionary = ["user": (activity["toUser"] as? PFUser)!, "followActivity" : activity ]
                arrayOfResults.append(dict)
            }
            
            self.searchResults = arrayOfResults
            self.resultsTable.hidden = false
            self.resultsTable.reloadData()
            
            
            }.always{
                SpinnerUtility.stopAnimatingForView(self.view)
            }
            .error { (error: ErrorType) -> Void in
                UIUtility.ShowAlert(self, title: "Error", message: "There was as problem with the request")
        }
        
    }
    
}
