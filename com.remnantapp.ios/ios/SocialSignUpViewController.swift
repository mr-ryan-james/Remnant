//
//  SocialSignUpViewController.swift
//  ios
//
//  Created by System Administrator on 10/15/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Parse

class SocialSignUpViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    var socialSignUpCompleteDelegate:SocialSignUpCompleteDelegate? = nil
    
    @IBAction func continueTapped(sender: AnyObject)
    {
        //call Facebook, get information, save to Parse, close window
        if(FBSDKAccessToken.currentAccessToken() != nil){
            let request:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name,email"])
            request.startWithCompletionHandler({ (connection, result, err) -> Void in
                
                if ((err) != nil)
                {
                    UIUtility.ShowAlert(self, title: "Error", message: "Unable to complete facebook request")
                }
                else
                {
                    
                    let user = PFUser.currentUser()
                    
                    user!.username = self.txtUsername.text
                    user!.email = result.valueForKey("email") as? String
                    user!["signUpComplete"] = true
                    

                    user!.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if(!success){
                            UIUtility.ShowAlert(self, title: "Error", message: "There was a problem with your request")
                            return
                        }

                        self.dismissViewControllerAnimated(true, completion: {
                            self.socialSignUpCompleteDelegate?.socialSignUpComplete()
                        })
                    })
                    
                }
            })
        }
        
        
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
