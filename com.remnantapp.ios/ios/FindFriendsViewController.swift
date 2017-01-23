//
//  FindFollowersViewController.swift
//  ios
//
//  Created by System Administrator on 11/2/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit
import PromiseKit
import Parse

class FindFriendsViewController: ResultsViewController, UISearchBarDelegate, SocialContainerChildViewController {

    var container:SocialFollowersViewController?
    
    @IBOutlet weak var searchByUsernameControl: UISearchBar!
    @IBOutlet weak var resultsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchByUsernameControl.delegate = self
        super.setTableViewOnSuperClass(resultsTable)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        SpinnerUtility.initializeSpinnerInViewDidAppear(self.view)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        SpinnerUtility.startAnimatingForView(self.view)
        DataAccessLayer.searchForUsername(searchBar.text!.lowercaseString).then { (results: NSDictionary?) -> Void in
            
            if(results == nil){
                self.searchResults = []
            }
            else{
                self.searchResults = [results!]
            }
            
            self.resultsTable.hidden = false
            self.resultsTable.reloadData()
        }.always{
                SpinnerUtility.stopAnimatingForView(self.view)
        }.error { (error: ErrorType) -> Void in
                UIUtility.ShowAlert(self, title: "Error", message: "There was as problem with the request")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    


}
