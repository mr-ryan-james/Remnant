//
//  SocialTimelineViewController.swift
//  ios
//
//  Created by System Administrator on 10/21/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation
import Parse

class SocialTimelineViewController: UIViewController, CustomNavbarDelegate, UIWebViewDelegate, LocationManagerDelegate {
    
    @IBOutlet weak var customNavbar: NavbarView!
    @IBOutlet weak var remnantListView: UIWebView!
    

    let locationManager = LocationManager()
    var selectedRemnant:String?
    
    var loadNewStuff = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        customNavbar.customNavbarDelegate = self
        customNavbar.titleLabel.text = "Timeline"
        customNavbar.leftButton.hidden = false
        customNavbar.leftButton.setTitle("Back", forState: UIControlState.Normal)
        
        remnantListView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        SpinnerUtility.initializeSpinnerInViewDidAppear(self.view)
        
        if(loadNewStuff == true){
            SpinnerUtility.startAnimatingForView(self.view)
            getLocationAndLoadRemnants()
        }
        else{
            loadNewStuff = true
        }
    }
    
    func leftButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rightButtonTapped() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocationAndLoadRemnants(){
        locationManager.locationWrapperDelegate = self
        locationManager.getLocation()
    }
    
    func locationManagerLocationUpdated(location: GeoLocation){
        getRemnantsAndBind(location)
    }
    
    func locationManagerFailedWithError(manager: CLLocationManager, didFailWithError error: NSError){
        print("Location request failed")
    }
    
    
    func getRemnantsAndBind(location:GeoLocation) {
        
        let lat = location.latitude
        let lng = location.longitude
        let dist = 10000
        
        
        let url = NSURL(string: "https://www.remnantapp.com/api/remnants/rendered?lat=\(lat)&lng=\(lng)&distance=\(dist)")
        let mRequest:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        mRequest.setValue(PFUser.currentUser()?.sessionToken, forHTTPHeaderField: "sessionToken")
        
        
        remnantListView.loadRequest(mRequest)
        
        print(url!)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(navigationType == UIWebViewNavigationType.LinkClicked){
            selectedRemnant = (request.URL!).absoluteString.stringByReplacingOccurrencesOfString("http://www.throwaway.com/", withString: "")
            print(selectedRemnant)
            
            self.performSegueWithIdentifier("remnantViewSegue", sender: self)
            
            
            return false
        }
        
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SpinnerUtility.stopAnimatingForView(self.view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {

        if(segue.identifier == "remnantViewSegue"){
            let destinationVC = segue.destinationViewController as! RemnantViewController
            destinationVC.remnantId = selectedRemnant
            loadNewStuff = false
        }
    }

}