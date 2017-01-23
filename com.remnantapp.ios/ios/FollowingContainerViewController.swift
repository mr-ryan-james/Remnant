                                                                                                     //
//  FollowingContainerViewController.swift
//  ios
//
//  Created by System Administrator on 11/2/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit

class FollowingContainerViewController: UIViewController {
    
    var containerHandler:ContainerBaseHandler<SocialFollowersViewController>?
    var container:SocialFollowersViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        containerHandler = ContainerBaseHandler<SocialFollowersViewController>(thisController: self, containerController: container!)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        containerHandler?.handleSegue(segue)
    }
    
    func performSegue(identifier:String){
        self.performSegueWithIdentifier(identifier, sender: self)
    }
    
}