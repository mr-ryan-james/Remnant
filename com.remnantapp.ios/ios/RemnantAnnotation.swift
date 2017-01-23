//
//  RemnantAnnotation.swift
//  ios
//
//  Created by puhfista on 8/26/15.
//  Copyright (c) 2015 puhfista. All rights reserved.
//

import Foundation
import MapKit

class RemnantAnnotation: NSObject, MKAnnotation {

    var locationName: String
    var coordinate: CLLocationCoordinate2D
    
    init(locationName: String, coordinate: CLLocationCoordinate2D) {
        
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}