//
//  LocationManager.swift
//  ios
//
//  Created by System Administrator on 9/29/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation

class LocationManager : NSObject, CLLocationManagerDelegate{
    
    static var lastGeolocation:GeoLocation? = nil
    
    class func setLatestGeolocation(location: GeoLocation) -> Void{
        lastGeolocation = location
    }
    
    class func getLatestGeolocation() -> GeoLocation?{
        return lastGeolocation
    }
    
    let locationManager = CLLocationManager()
    var locationWrapperDelegate = LocationManagerDelegate?()

    func getLocation(force:Bool = false){
        let lastGeolocation = LocationManager.getLatestGeolocation()
        if(!force && lastGeolocationIsRecent(lastGeolocation, threshold: 10)){
            locationWrapperDelegate?.locationManagerLocationUpdated(lastGeolocation!)
            return
        }
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(manager.location == nil){
            return
        }
        
        manager.stopUpdatingLocation()
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        let geoLocation = GeoLocation(lat: Double(locValue.latitude), lng: Double(locValue.longitude))
        let lastRunGeolocation:GeoLocation? = LocationManager.getLatestGeolocation()
        
        LocationManager.setLatestGeolocation(geoLocation)
        
        if(!lastGeolocationIsRecent(lastRunGeolocation, threshold: 0.2)){
            locationWrapperDelegate?.locationManagerLocationUpdated(geoLocation)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationWrapperDelegate?.locationManagerFailedWithError(manager, didFailWithError: error)
    }
    
    func lastGeolocationIsRecent(geolocation:GeoLocation?, threshold:Double = 1) -> Bool{
        if(geolocation == nil){
            return false
        }
        
        let rightNow = CFAbsoluteTimeGetCurrent()
        let difference = rightNow - geolocation!.dateTimeRetrieved

        NSLog("Difference: \(difference)")

        if(difference < threshold){
            return true
        }
        
        return false
    }
}