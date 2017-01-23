//
//  TakePhotoViewController.swift
//  ios
//
//  Created by puhfista on 9/15/15.
//  Copyright (c) 2015 puhfista. All rights reserved.
//

import UIKit
import AVFoundation
import GPUImage

class TakePhotoViewController: UIViewController {

    @IBOutlet weak var takePhotoImageView: UIImageView!
    @IBOutlet weak var cancelImageView: UIImageView!
    @IBOutlet weak var filterView: GPUImageView!
    var videoCamera: GPUImageStillCamera
    var filter: GPUImageCropFilter
    
    var photoTakenDelegate = PhotoTakenDelegate?()
    
    
    required init(coder aDecoder: NSCoder)
    {

        videoCamera = GPUImageStillCamera(sessionPreset: AVCaptureSessionPreset640x480, cameraPosition: .Back)
        videoCamera.outputImageOrientation = .Portrait;
        filter = GPUImageCropFilter(cropRegion: CGRect(x: 0, y: 0, width: 1, height: 0.75))
        let screenRect  = UIScreen.mainScreen().bounds
        filter.forceProcessingAtSizeRespectingAspectRatio(CGSize(width: screenRect.width, height: screenRect.width))
        videoCamera.addTarget(filter)


        
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cancelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "cancelTapped")
        let takePhototapGestureRecognizer = UITapGestureRecognizer(target: self, action: "takePhotoTapped")
        
        cancelImageView.addGestureRecognizer(cancelTapGestureRecognizer)
        cancelImageView.image = UIImage.fontAwesomeIconWithName(FontAwesome(rawValue: FontAwesomeIcons["fa-times"]!)!, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        takePhotoImageView.addGestureRecognizer(takePhototapGestureRecognizer)
        takePhotoImageView.image = UIImage.fontAwesomeIconWithName(FontAwesome(rawValue: FontAwesomeIcons["fa-camera"]!)!, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
        let screenRect  = UIScreen.mainScreen().bounds
        filterView.frame = CGRect(x:0, y:0,width: screenRect.width, height: screenRect.width)
        filter.addTarget(filterView)
        videoCamera.startCameraCapture()
    }
    
    

    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func takePhotoTapped() {
        videoCamera.capturePhotoAsJPEGProcessedUpToFilter(filter) { (processedJPG, err) -> Void in
            //croppedImage = UIImage(data: processedJPG)!
            
            let editImageViewController: EditImageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditImage") as! EditImageViewController
            editImageViewController.imageFromCamera = UIImage(data: processedJPG)!
            editImageViewController.photoTakenDelegate = self.photoTakenDelegate
            self.presentViewController(editImageViewController, animated: true, completion: nil)
            
            
            //self.performSegueWithIdentifier("imageEditorSegue", sender: self)
            
            //self.photoTakenDelegate?.photoTaken(image)
            
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }


    func cancelTapped() {
        //self.dismissViewControllerAnimated(true, completion: nil)
        
        performSegueWithIdentifier("backToNewRemnantSegue", sender: self)
    }
   
}
