//
//  SocialFindFriendsViewController.swift
//  ios
//
//  Created by System Administrator on 10/17/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit

class SocialFollowersViewController: UIViewController, UITabBarDelegate, CustomNavbarDelegate {

    @IBOutlet weak var friendsTabBar: UITabBar!
    @IBOutlet weak var customNavbar: NavbarView!
    @IBOutlet weak var followingContainer: UIView!
    
    @IBOutlet weak var findButton: UITabBarItem!
    @IBOutlet weak var followingButton: UITabBarItem!
    @IBOutlet weak var followersButton: UITabBarItem!
    @IBOutlet weak var connectButton: UITabBarItem!
    
    var followingContainerViewController:FollowingContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customNavbar.customNavbarDelegate = self

        customNavbar.titleLabel.text = "Friends"
        customNavbar.leftButton.hidden = false
        customNavbar.leftButton.setTitle("Back", forState: UIControlState.Normal)
        
        findButton.setupFontAwesome("fa-search")
        followingButton.setupFontAwesome("fa-child")
        followersButton.setupFontAwesome("fa-thumbs-up")
        connectButton.setupFontAwesome("fa-users")
        
        friendsTabBar.delegate = self
        friendsTabBar.selectedItem = findButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        findTapped()
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.title!.lowercaseString{
        case "find":
            findTapped()
            break
        case "following":
            followingTapped()
            break;
        case "followers":
            followersTapped()
            break;
        case "connect":
            connectTapped()
        default:
            break;
        }
    }
    
    func findTapped(){
        followingContainerViewController?.performSegue("findFriendsChildSegue")
    }
    
    func followingTapped(){
        followingContainerViewController?.performSegue("followingChildSegue")
    }
    
    func followersTapped(){
        followingContainerViewController?.performSegue("followersChildSegue")
    }
    
    func connectTapped(){
        followingContainerViewController?.performSegue("socialConnectChildSegue")
    }
    
    func leftButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rightButtonTapped() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "socialContainerEmbedSegue"){
            followingContainerViewController = segue.destinationViewController as? FollowingContainerViewController
            followingContainerViewController!.container = self
        }
    }

}
