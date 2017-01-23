//
//  RemnantLocationController.swift
//  ios
//
//  Created by puhfista on 8/26/15.
//  Copyright (c) 2015 puhfista. All rights reserved.
//

import Foundation
import MapKit

class RemnantLocationController : UIViewController, CustomNavbarDelegate {
    
    @IBOutlet weak var customNavbar: NavbarView!
    @IBOutlet weak var remnantLocationMap: MKMapView!
    var selectedRemnant:Remnant = Remnant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavbar.customNavbarDelegate = self
        customNavbar.titleLabel.text = "location"
        customNavbar.leftButton.hidden = false
        customNavbar.leftButton.setTitle("Back", forState: UIControlState.Normal)
    }
    
    func leftButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rightButtonTapped() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let initialLocation = CLLocation(latitude: selectedRemnant.Geolocation!.latitude, longitude: selectedRemnant.Geolocation!.longitude)
        centerMapOnLocation(initialLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        remnantLocationMap.setRegion(coordinateRegion, animated: false)
        
        let remnantAnnotation = RemnantAnnotation(locationName: selectedRemnant.Desc, coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        
        remnantLocationMap.addAnnotation(remnantAnnotation)
        remnantLocationMap.selectAnnotation(remnantAnnotation, animated: true)
    }
}