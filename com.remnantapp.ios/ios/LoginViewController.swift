//
//  LoginViewController.swift
//  ios
//
//  Created by System Administrator on 12/29/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation
import ParseUI

class LoginViewController : PFLogInViewController {
    
    var backgroundImage : UIImageView!;
    var viewsToAnimate: [UIView!]!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeButton(logInView?.facebookButton!, color: UIColor.blueColor())
        //customizeButton(logInView?.twitterButton!)
        customizeButton(logInView?.signUpButton!, color: UIColor.darkGrayColor())
        
        // set our custom background image
        backgroundImage = UIImageView(image: UIImage(named: "clouds"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFit
        backgroundImage.alpha = 0.45
        self.logInView!.insertSubview(backgroundImage, atIndex: 0)
        
        let logo = UILabel()
        logo.text = "Remnant"
        logo.textColor = UIColor.darkGrayColor()
        logo.font = UIFont(name: "Born", size: 70)
        logo.shadowColor = UIColor.lightGrayColor()
        logo.shadowOffset = CGSizeMake(2, 2)
        logInView?.logo = logo
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        
        logInView!.logo!.sizeToFit()
        
        let logoFrame = logInView!.logo!.frame
        logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height)
        
        logInView?.logInButton?.setBackgroundImage(nil, forState: .Normal)
        logInView?.logInButton?.backgroundColor = UIColor.darkGrayColor()
        
        self.facebookPermissions = ["public_profile", "email", "user_friends"]
        
        let swipeButtonDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "facebookTapped")
        logInView?.facebookButton!.addGestureRecognizer(swipeButtonDown)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    func facebookTapped(){
        print("facebook tapped")
    }
    
    func customizeButton(button: UIButton!, color: UIColor) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = color.CGColor
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
    }
}