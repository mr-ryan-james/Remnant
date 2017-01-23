//
//  NewRemnantController.swift
//  ios
//
//  Created by puhfista on 8/28/15.
//  Copyright (c) 2015 puhfista. All rights reserved.
//

import FBSDKCoreKit
import UIKit
import Parse
import PromiseKit

class NewRemnantController: UIViewController, LocationManagerDelegate, PhotoTakenDelegate, UITextViewDelegate, CustomNavbarDelegate {
    
    @IBOutlet weak var customNavigationBar: NavbarView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var shareFacebookBtn: UIButton!
    
    var fileUploadBackgroundTaskId: UIBackgroundTaskIdentifier!
    var photoPostBackgroundTaskId: UIBackgroundTaskIdentifier!
    
    var photoFile: PFFile?
    var isSavingRemnant = false
    var geoLocation:GeoLocation?
    
    let locationManager = LocationManager()
    var remnantAddedDelegate:RemnantAddedDelegate? = RemnantAddedDelegate?()
    
    var descriptionFirstEdit = "Tell us about this remnant..."
    var shareOnFacebook = false

    
    @IBAction func backToNewRemnant(segue: UIStoryboardSegue) {
        NSLog("backToNewRemnant")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("New remnant controller initialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomNavigationBar()
        txtDescription.text = descriptionFirstEdit
        
        txtDescription.layer.borderWidth = 1
        txtDescription.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtDescription.layer.cornerRadius = 5
        
        shareFacebookBtn.layer.borderWidth = 1
        shareFacebookBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        shareFacebookBtn.layer.cornerRadius = 5
        
        if(!Facebook.isUserLinkedToFacebook(PFUser.currentUser()!)){
            shareFacebookBtn.setTitle("Connect with Facebook", forState: .Normal)
        }
        
        self.txtDescription.delegate = self;
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if(txtDescription.text == descriptionFirstEdit){
            txtDescription.text = ""
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            self.view.endEditing(true);
        }
        super.touchesBegan(touches, withEvent:event)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        SpinnerUtility.initializeSpinnerInViewDidAppear(self.view)
        locationManager.locationWrapperDelegate = self
        
        if(geoLocation == nil){
            SpinnerUtility.startAnimatingForView(self.view)
            customNavigationBar.rightButton.enabled = false
            locationManager.getLocation()
        }
    }
    
    func setupCustomNavigationBar(){
        customNavigationBar.customNavbarDelegate = self
        customNavigationBar.titleLabel.text = "new remnant"
        customNavigationBar.leftButton.setTitle("Cancel", forState: UIControlState.Normal)
        customNavigationBar.rightButton.setTitle("Save", forState: UIControlState.Normal)
        customNavigationBar.leftButton.hidden = false
        customNavigationBar.rightButton.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rightButtonTapped() {
        customNavigationBar.rightButton.enabled = false
        SpinnerUtility.startAnimatingForView(self.view)
        saveRemnant()
    }
    
    func locationManagerLocationUpdated(location:GeoLocation) {
        print("locations = \(location.latitude) \(location.longitude)")
        geoLocation = location
        SpinnerUtility.stopAnimatingForView(self.view)
        customNavigationBar.rightButton.enabled = true
    }
    
    func locationManagerFailedWithError(manager: CLLocationManager, didFailWithError error: NSError) {
        customNavigationBar.rightButton.enabled = true
        SpinnerUtility.stopAnimatingForView(self.view)
        isSavingRemnant = false
    }
    
    func saveRemnant() {
        if(isSavingRemnant){
            return
        }
        
        isSavingRemnant = true
        
        // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
        self.fileUploadBackgroundTaskId = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            UIApplication.sharedApplication().endBackgroundTask(self.fileUploadBackgroundTaskId)
        }
        
        let pfGeo = PFGeoPoint(latitude: geoLocation!.latitude, longitude: geoLocation!.longitude)
        DataAccessLayer.addNewRemnant(txtDescription.text, photoFile: self.photoFile, pfGeo: pfGeo).then { (pfRemnant:PFObject) -> Promise<AnyObject> in
            
            self.dismissViewControllerAnimated(true, completion: {
                let remnant = Remnant()
                
                remnant.Geolocation = GeoLocation(lat: self.geoLocation!.latitude, lng: self.geoLocation!.longitude)
                remnant.Desc = self.txtDescription.text
                self.remnantAddedDelegate?.remnantAdded(remnant)
            })
            
            if(self.shareOnFacebook){
                self.postToFacebook(pfRemnant)
            }
            
            return DataAccessLayer.postProcessRemnant(pfRemnant.objectId!)
            
            }.then{ success -> Void in
                print("finished post processing")
            }
            .always{
                UIApplication.sharedApplication().endBackgroundTask(self.fileUploadBackgroundTaskId)
            }
            .error { (error: ErrorType) -> Void in
                UIUtility.ShowAlert(self, title: "Error", message: "There was as problem with the Remnant upload")
        }
        
    }
    
    func postToFacebook(pfRemnant:PFObject){
        if(!Facebook.isUserLinkedToFacebook(PFUser.currentUser()!) || !Facebook.hasGrantedPublishPermissions()){
            return
        }
        
        Facebook.postToFacebook(pfRemnant).then { (result:AnyObject) -> Void in
            print("posted to facebook")
        }
        .error { (error: ErrorType) -> Void in
            print("error posting to facebook: \(error)")
        }
    }
    
    
    @IBAction func addPhotoTapped(sender: AnyObject) {
        performSegueWithIdentifier("takePhotoSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "takePhotoSegue"){
            let takePhotoController = (segue.destinationViewController as! TakePhotoViewController)
            takePhotoController.photoTakenDelegate = self
        }
        else if(segue.identifier == "photoStoryboardSegue"){
            let photoViewController = (segue.destinationViewController as!  ImageEditor)
            
            //photoViewController.photoAddedDelegate = self
        }
    }
    
    func photoTaken(image: UIImage) {
        imageView.image = image
        
        uploadRemnantPhoto(image)
    }
    
    func addRemnant(){
        
    }
    
    func uploadRemnantPhoto(image: UIImage) -> Void{
        let image:UIImage = imageView.image!.resizedImageWithContentMode(UIViewContentMode.ScaleAspectFit, bounds: CGSizeMake(640, 640), interpolationQuality: CGInterpolationQuality.High)
        let imageData = UIImageJPEGRepresentation(image, 0.7)!
        
        self.photoFile = PFFile(name: "remnantPhoto.jpg", data: imageData)
        
        self.photoPostBackgroundTaskId = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            UIApplication.sharedApplication().endBackgroundTask(self.photoPostBackgroundTaskId)
        }
        
        DataAccessLayer.uploadPhoto(self.photoFile!).then { (savedFile:PFFile) -> Void in
            print("Photo uploaded successfully")
            }.always{
                print("Killing background task")
                UIApplication.sharedApplication().endBackgroundTask(self.photoPostBackgroundTaskId)
            }
            .error { (error: ErrorType) -> Void in
                UIUtility.ShowAlert(self, title: "Error", message: "There was as problem with the photo upload")
        }
    }
    
    @IBAction func shareFacebookTapped(sender: AnyObject) {
        shareOnFacebook = !shareOnFacebook

        if(!shareOnFacebook){
            self.toggleFacebookButton(self.shareOnFacebook)
            return
        }
        
        if(!Facebook.isUserLinkedToFacebook(PFUser.currentUser()!)){
            askForFacebookPermissions()
            return
        }

        if(shareOnFacebook){
            checkForPublishPermissions()
        }
        else{
            toggleFacebookButton(shareOnFacebook)
        }

    }
    
    func askForFacebookPermissions(){
        Facebook.askForPublishActionsFirstTime(PFUser.currentUser()!).then { (allowedConnection:Bool) -> Void in
                self.shareOnFacebook = allowedConnection
                self.toggleFacebookButton(self.shareOnFacebook)
            }
            .error { (error: ErrorType) -> Void in
                print("unable to ask facebook if we can publish: \(error)")
        }
    }
    
    func checkForPublishPermissions(){
        if(!Facebook.hasGrantedPublishPermissions()){
            Facebook.askForPublishActions(self).then { (allowedPublish:Bool) -> Void in
                    self.shareOnFacebook = allowedPublish
                    self.toggleFacebookButton(self.shareOnFacebook)
                }
                .error { (error: ErrorType) -> Void in
                    print("unable to ask facebook if we can publish")
            }
            
        }
        else{
            toggleFacebookButton(shareOnFacebook)
        }
    }
    
    func toggleFacebookButton(shareToFacebook:Bool){
        if(shareOnFacebook){
            shareFacebookBtn.backgroundColor = UIColor.blueColor()
            shareFacebookBtn.titleLabel?.textColor = UIColor.whiteColor()
        }
        else{
            shareFacebookBtn.backgroundColor = UIColor.clearColor()
            shareFacebookBtn.titleLabel?.textColor = UIColor.blueColor()
        }
    }
    
}
