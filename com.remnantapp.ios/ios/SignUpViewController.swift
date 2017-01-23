//
//  SignUpViewController.swift
//  ios
//
//  Created by System Administrator on 12/29/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation
import ParseUI

class SignUpViewController : PFSignUpViewController {
    
    var backgroundImage : UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set our custom background image
        backgroundImage = UIImageView(image: UIImage(named: "roadSign"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        signUpView!.insertSubview(backgroundImage, atIndex: 0)
        
        // remove the parse Logo
        let logo = UILabel()
        logo.text = "Remnant"
        logo.textColor = UIColor.darkGrayColor()
        logo.font = UIFont(name: "Born", size: 70)
        logo.shadowColor = UIColor.lightGrayColor()
        logo.shadowOffset = CGSizeMake(2, 2)
        signUpView?.logo = logo
        
        customizeButton(signUpView?.signUpButton, color: UIColor.whiteColor())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        backgroundImage.frame = CGRectMake( 0,  0,  signUpView!.frame.width,  signUpView!.frame.height)
        
        // position logo at top with larger frame
        signUpView!.logo!.sizeToFit()
        let logoFrame = signUpView!.logo!.frame
        signUpView!.logo!.frame = CGRectMake(logoFrame.origin.x, signUpView!.usernameField!.frame.origin.y - logoFrame.height - 16, signUpView!.frame.width,  logoFrame.height)
    }
    
    func customizeButton(button: UIButton!, color: UIColor) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.5)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = color.CGColor
    }
    
}