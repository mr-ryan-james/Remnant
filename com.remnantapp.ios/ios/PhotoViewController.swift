//
//  PhotoViewController.swift
//  ios
//
//  Created by puhfista on 9/7/15.
//  Copyright (c) 2015 puhfista. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, PhotoTakenDelegate {

    var loaded = false
    var imagePicker: UIImagePickerController!
    
    @IBOutlet var cameraOverlay: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var photoAddedDelegate = PhotoAddedDelegate?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if(!loaded){
            loaded = true
            
            performSegueWithIdentifier("showCameraSegue", sender: self)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //performSegueWithIdentifier("showCameraSegue", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func photoTaken(image: UIImage) -> Void {
        imageView.image = image
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        performSegueWithIdentifier("backToNewRemnantSegue", sender: self)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        saveButton.enabled = false

        photoAddedDelegate?.photoAdded(imageView.image!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showCameraSegue"){
            let takePhotoViewController = (segue.destinationViewController as! TakePhotoViewController)
            takePhotoViewController.photoTakenDelegate = self
        }
    }
    
}
