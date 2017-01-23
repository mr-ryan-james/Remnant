//
//  Remnant.swift
//  ios
//
//  Created by puhfista on 8/25/15.
//  Copyright (c) 2015 puhfista. All rights reserved.
//

import Foundation
import Parse

class Remnant{
    var UserId: String = ""
    var UserName: String = ""
    var Desc: String = ""
    var Image:NSData? = nil
    var Geolocation:GeoLocation? = nil
    var CreatedOn:NSDate?  = nil
    
    class func parsePFObject(item:PFObject)  -> Remnant{
        let remnant = Remnant()
        
        remnant.UserId = (item.objectForKey(kRemnantUserKey)?.objectId)!
        remnant.UserName = item.objectForKey(kRemnantUserNameKey) as! String
        remnant.Image = item.objectForKey(kRemnantPhotoKey) as? NSData
        remnant.Desc = item.objectForKey(kRemnantDescriptionKey) as! String
        remnant.CreatedOn = item.createdAt
        
        let pfGeopoint = item.objectForKey("geolocation") as! PFGeoPoint
        
        remnant.Geolocation = GeoLocation(lat: pfGeopoint.latitude, lng: pfGeopoint.longitude)
        
        return remnant
    }
    
}