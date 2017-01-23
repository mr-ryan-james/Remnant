//
//  SettingsViewController.swift
//  ios
//
//  Created by System Administrator on 10/20/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController, CustomNavbarDelegate {
    
    @IBOutlet weak var navbarController: NavbarView!

    @IBAction func logOutTapped(sender: AnyObject) {
        PFUser.logOut()
        PFInstallation.currentInstallation().removeObjectForKey("user")
        PFInstallation.currentInstallation().saveInBackground()
        performSegueWithIdentifier("backToStartup", sender: self)
    }
    
    override func viewDidLoad() {
        navbarController.customNavbarDelegate = self
        navbarController.titleLabel.text = "Settings"
        navbarController.leftButton.hidden = false
        navbarController.leftButton.setTitle("Back", forState: UIControlState.Normal)
    }

    func leftButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rightButtonTapped() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "backToStartup"){
            let startupViewController = segue.destinationViewController as! StartupViewController
            startupViewController.isInitialLoad = true
        }
    }
    
}