//
//  DataAccessLayer.swift
//  ios
//
//  Created by System Administrator on 11/3/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

class DataAccessLayer{
    
    class func followUser(user:PFUser) -> Promise<PFObject?>{
        return Promise { fulfill, reject in
            let activity = PFObject(className: kActivityClassKey)
            let currentUser = PFUser.currentUser()!
            activity.setObject(currentUser, forKey: kActivityFromUserKey)
            activity.setObject(user, forKey: kActivityToUserKey)
            activity.setObject("follow", forKey: kActivityTypeKey)
            
            activity.saveInBackgroundWithBlock({ (success:Bool, error: NSError?) -> Void in
                
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(activity)
            })
        }
    }
    
    class func unfollowUser(followActivity:PFObject) -> Promise<Bool>{
        return Promise { fulfill, reject in
            followActivity.deleteInBackgroundWithBlock({ (success:Bool, error: NSError?) -> Void in
                
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(success)
            })
        }
    }
    
    class func getUsersFollowingCurrentUser()-> Promise<[PFObject]?>{
        let currentUser = PFUser.currentUser()!
        
        return Promise { fulfill, reject in
            
            let query = PFQuery(className:"Activity")
            query.includeKey("fromUser")
            query.whereKey("toUser", equalTo: currentUser)
            query.whereKey("type", equalTo:"follow")
            
            query.findObjectsInBackgroundWithBlock { (activities: [PFObject]?, error: NSError?) -> Void in
                
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(activities)
            }
        }
    }
    
    class func getUsersFollowedByCurrentUser()-> Promise<[PFObject]?>{
        let currentUser = PFUser.currentUser()!
        
        return Promise { fulfill, reject in
            
            let query = PFQuery(className:"Activity")
            query.includeKey("toUser")
            query.whereKey("fromUser", equalTo: currentUser)
            query.whereKey("type", equalTo:"follow")
            
            query.findObjectsInBackgroundWithBlock { (activities: [PFObject]?, error: NSError?) -> Void in
                
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(activities)
            }
        }
    }
    
    class func searchForUsername(username:String) -> Promise<NSDictionary?> {
        return Promise { fulfill, reject in
            
            PFCloud.callFunctionInBackground("searchForUsername", withParameters: ["username": username], block: {
                (result: AnyObject?, error: NSError?) -> Void in
                if ( error === nil) {
                    NSLog("searchForUsername call back: \(result) ")
                    fulfill(result as? NSDictionary)
                    
                }
                else if (error != nil) {
                    NSLog("error in generateThumbnail: \(error!.userInfo)")
                    reject(error!)
                }
            })
        }
    }
    
    class func addNewRemnant(description:String, photoFile:PFFile?, pfGeo:PFGeoPoint) -> Promise<PFObject>{
        return Promise { fulfill, reject in
            
            let pfRemnant = PFObject(className: kRemnantClassKey)
            let currentUser = PFUser.currentUser()!
            pfRemnant.setObject(currentUser, forKey: kRemnantUserKey)
            pfRemnant.setObject(currentUser.username!, forKey: kRemnantUserNameKey)
            pfRemnant.setObject(pfGeo, forKey: kRemnantGeolocationKey)
            pfRemnant.setObject(description, forKey: kRemnantDescriptionKey)
            
            if(photoFile != nil){
                pfRemnant.setObject(photoFile!, forKey: kRemnantPhotoKey)
            }
            
            // photos are public, but may only be modified by the user who uploaded them
//            let remnantACL = PFACL(user: PFUser.currentUser()!)
//            remnantACL.setPublicReadAccess(true)
//            pfRemnant.ACL = remnantACL
            
            pfRemnant.saveInBackgroundWithBlock({ (success:Bool, error: NSError?) -> Void in
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(pfRemnant)
            })
        }
    }
    
    class func postProcessRemnant(remnantId: String) -> Promise<AnyObject>{
        return Promise { fulfill, reject in
            PFCloud.callFunctionInBackground("postProcessRemnant", withParameters: ["remnantId": remnantId], block: {
                (result: AnyObject?, error: NSError?) -> Void in
                if ( error != nil) {
                    reject(error!)
                    return
                }
                
                fulfill(result!)
            })
        }
    }
    
    class func uploadPhoto(photoFile:PFFile) -> Promise<PFFile>{
        
        return Promise { fulfill, reject in
            photoFile.saveInBackgroundWithBlock { (succeeded, error) in
                if (succeeded) {
                    fulfill(photoFile)
                } else {
                    reject(error!)
                }
            }
        }
    }
    
    class func getRemnant(id:String) -> Promise<PFObject?>{
        return Promise { fulfill, reject in
            
            let query = PFQuery(className:"Remnant")
            query.getObjectInBackgroundWithId(id, block: { (remnant:PFObject?, error:NSError?) -> Void in
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(remnant)
            })
        }
    }
    
    class func getRemnantForDetailView(remnantId:String)  -> Promise<NSDictionary?> {
        return Promise { fulfill, reject in
            
            PFCloud.callFunctionInBackground("getRemnantForDetailView", withParameters: ["remnantId": remnantId], block: {
                (result: AnyObject?, error: NSError?) -> Void in
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(result as? NSDictionary)
            })
        }
    }
    
    class func likeRemnant(remnantId:String, toUser:String)  -> Promise<PFObject?> {
        return Promise { fulfill, reject in
            
            PFCloud.callFunctionInBackground("likeRemnant", withParameters: ["remnantId": remnantId, "toUser" : toUser], block: {
                (likeActivity: AnyObject?, error: NSError?) -> Void in
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(likeActivity as? PFObject)
            })
        }
    }
    
    class func unlikeRemnant(remnantId:String, likeActivityId:String) -> Promise<AnyObject?>{
        return Promise { fulfill, reject in
            PFCloud.callFunctionInBackground("unlikeRemnant", withParameters: ["remnantId": remnantId, "likeActivityId" : likeActivityId], block: {
                (result: AnyObject?, error: NSError?) -> Void in
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(result)
            })
        }
    }
    
    class func addComment(remnantId:String, toUserId:String, comment:String)  -> Promise<PFObject?>{
        return Promise { fulfill, reject in
            let activity = PFObject(className: kActivityClassKey)
            let currentUser = PFUser.currentUser()!
            
            let toUser = PFUser(withoutDataWithClassName: "_User", objectId: toUserId)
            let remnant = PFObject(withoutDataWithClassName: "Remnant", objectId: remnantId)
            
            activity.setObject(currentUser, forKey: kActivityFromUserKey)
            activity.setObject(toUser, forKey: kActivityToUserKey)
            activity.setObject("comment", forKey: kActivityTypeKey)
            activity.setObject(comment, forKey: "content")
            activity.setObject(remnant, forKey: "remnant")
            
            activity.saveInBackgroundWithBlock({ (success:Bool, error: NSError?) -> Void in
                
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(activity)
            })
        }
    }
    

    class func getCommentsForRemnant(remnantId:String)-> Promise<[PFObject]?>{
        return Promise { fulfill, reject in
            let remnant = PFObject(withoutDataWithClassName: "Remnant", objectId: remnantId)
            let query = PFQuery(className:"Activity")
            query.includeKey("fromUser")
            query.whereKey("remnant", equalTo: remnant)
            query.whereKey("type", equalTo:"comment")
            query.addAscendingOrder("createdAt")
            
            query.findObjectsInBackgroundWithBlock { (activities: [PFObject]?, error: NSError?) -> Void in
                
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(activities)
            }
        }
    }
    
    class func getAlertsForUser()-> Promise<[PFObject]?>{
        return Promise { fulfill, reject in
            
            let currentUser = PFUser.currentUser()
            let query = PFQuery(className:"Activity")
            query.includeKey("fromUser")
            query.includeKey("remnant")
            query.whereKey("toUser", equalTo: currentUser!)
            query.addDescendingOrder("createdAt")
            
            query.findObjectsInBackgroundWithBlock { (activities: [PFObject]?, error: NSError?) -> Void in
                
                if(error != nil){
                    reject(error!)
                    return
                }
                
                fulfill(activities)
            }
        }
    }
    
}