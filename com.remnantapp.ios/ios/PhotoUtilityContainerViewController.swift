//
//  PhotoUtilityContainerViewController.swift
//  ios
//
//  Created by System Administrator on 10/27/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit

class PhotoUtilityContainerViewController: UIViewController {

    var containerHandler:ContainerBaseHandler<EditImageViewController>?
    var container:EditImageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        containerHandler = ContainerBaseHandler<EditImageViewController>(thisController: self, containerController: container!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var childViewController = segue.destinationViewController as! PhotoContainerChildViewController
        childViewController.container = container
        
        containerHandler?.handleSegue(segue)
    }
    
    func performSegue(identifier:String){
        self.performSegueWithIdentifier(identifier, sender: self)
    }

}
