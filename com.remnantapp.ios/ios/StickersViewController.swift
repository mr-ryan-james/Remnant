//
//  StickersViewController.swift
//  ios
//
//  Created by System Administrator on 10/27/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit

class StickersViewController: UIViewController, PhotoContainerChildViewController {
    typealias ParentContainerType = EditImageViewController
    
    var container:ParentContainerType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
