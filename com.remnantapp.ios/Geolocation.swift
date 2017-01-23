//
//  Geolocation.swift
//  ios
//
//  Created by puhfista on 8/26/15.
//  Copyright (c) 2015 puhfista. All rights reserved.
//

import Foundation

class GeoLocation{
    
    var latitude:Double
    var longitude:Double
    var dateTimeRetrieved:CFAbsoluteTime

    
    init(lat:Double, lng:Double) {
        latitude = lat
        longitude = lng
        
        dateTimeRetrieved = CFAbsoluteTimeGetCurrent()

    }
    

}