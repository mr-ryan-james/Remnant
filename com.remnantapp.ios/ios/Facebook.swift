//
//  Facebook.swift
//  ios
//
//  Created by System Administrator on 12/29/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import PromiseKit
import Parse
import ParseFacebookUtilsV4

class Facebook{
    
    class func postToFacebook(pfRemnant:PFObject) -> Promise<AnyObject>{
        return Promise { fulfill, reject in
            
            let photo = (pfRemnant["photo"] as! PFFile)
            
            let params = ["message": "",
                "link": "http://www.remnantapp.com/api/remnant/rendered/\(pfRemnant.objectId!)",
                "name": "",
                "caption": "remnant",
                "title": "",
                "description": pfRemnant["description"],
                "picture": photo.url!]
            
            FBSDKGraphRequest(graphPath: "me/feed", parameters: params, HTTPMethod: "POST").startWithCompletionHandler({ (connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
                if(error != nil){
                    reject(error!)
                    return
                }
                                    
                fulfill(result)
            })
            
        }
    }
    
    class func loginWithFacebookPermissions(user: PFUser) -> Promise<Bool>{
        return Promise { fulfill, reject in
            
            
            PFFacebookUtils.linkUserInBackground(user, withPublishPermissions: ["public_profile", "email", "user_friends"], block: { (success: Bool, error: NSError?) -> Void in
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(success)
            })
            
        }
    }
    
    class func askForPublishActionsFirstTime(user: PFUser) -> Promise<Bool>{
        return Promise { fulfill, reject in
            
            PFFacebookUtils.linkUserInBackground(user, withPublishPermissions: ["publish_actions"], block: { (success: Bool, error: NSError?) -> Void in
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(success)
            })
            
        }
    }
    
    class func askForPublishActions(viewController: UIViewController) -> Promise<Bool>{
        return Promise { fulfill, reject in
            
            FBSDKLoginManager().logInWithPublishPermissions(["publish_actions"], fromViewController: viewController, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                if(error != nil){
                    reject(error!)
                    return
                }
                
                if (result.declinedPermissions == nil || result.declinedPermissions.contains("publish_actions")) {
                    fulfill(false)
                } else {
                    fulfill(true)
                }
                
            })
            
        }
    }
    
    class func isUserLinkedToFacebook(user: PFUser) -> Bool{
        return PFFacebookUtils.isLinkedWithUser(user)
    }
    
    class func hasGrantedPublishPermissions() -> Bool{
        return FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions")
    }
}