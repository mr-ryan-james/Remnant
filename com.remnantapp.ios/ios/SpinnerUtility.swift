//
//  SpinnerUtility.swift
//  ios
//
//  Created by System Administrator on 11/4/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation

class SpinnerUtility {
    
    static var tag = 13002
    
    class func initializeSpinnerInViewDidAppear(view: UIView){
        var spinner:UIActivityIndicatorView? = view.viewWithTag(tag) as? UIActivityIndicatorView
        
        if(spinner == nil){
            spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            spinner!.tag = tag
            spinner!.color = UIColor.blackColor()
            spinner!.frame = CGRectMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds), 20, 20);
            spinner!.transform = CGAffineTransformMakeScale(2, 2);
            view.addSubview(spinner!); // spinner is not visible until started
        }
        else{
            spinner!.frame = CGRectMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds), 20, 20);
            spinner!.transform = CGAffineTransformMakeScale(2, 2);
        }
    }
    
    class func initializeSpinnerInViewDidLoad(view:UIView){
        var spinner:UIActivityIndicatorView? = view.viewWithTag(tag) as? UIActivityIndicatorView
        
        if(spinner == nil){
            spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            spinner!.tag = tag
            spinner!.color = UIColor.blackColor()
            view.addSubview(spinner!); // spinner is not visible until started
        }
    }
    
    class func startAnimatingForView(view: UIView){
        let spinner = view.viewWithTag(tag) as? UIActivityIndicatorView
        
        if(spinner == nil){
            print("trying to use spinner that has not been initialized yet")
            return
        }
        
        spinner?.startAnimating()
    }
    
    class func stopAnimatingForView(view: UIView){
        let spinner = view.viewWithTag(tag) as? UIActivityIndicatorView
        
        if(spinner == nil){
            print("trying to use spinner that has not been initialized yet")
            return
        }
        
        spinner?.stopAnimating()
    }
}