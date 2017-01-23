//
//  UIUtility.swift
//  ios
//
//  Created by System Administrator on 10/15/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation


class UIUtility{
    
    class func ShowAlert(viewController: UIViewController, title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    class func GetCenterOfView(view:UIView) -> CGPoint{
        return CGPointMake( view.bounds.size.width / 2, view.bounds.size.height / 2);
    }
    
}