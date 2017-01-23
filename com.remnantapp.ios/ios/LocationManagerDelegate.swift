//
//  LocationManagerDelegate.swift
//  ios
//
//  Created by System Administrator on 9/29/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation

protocol LocationManagerDelegate {
    func locationManagerLocationUpdated(location: GeoLocation) -> Void
    func locationManagerFailedWithError(manager: CLLocationManager, didFailWithError error: NSError) -> Void
}