//
//  RemnantWorldWrapperController.swift
//  ios
//
//  Created by puhfista on 8/27/15.
//  Copyright (c) 2015 puhfista. All rights reserved.
//

import UIKit

class RemnantWorldWrapperController: UIViewController {

    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
