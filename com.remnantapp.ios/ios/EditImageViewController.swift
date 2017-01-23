//
//  EditImageViewController.swift
//  ios
//
//  Created by System Administrator on 10/26/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController, UITabBarDelegate {
    @IBOutlet weak var cancelButton: UIImageView!
    @IBOutlet weak var confirmButton: UIImageView!
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var utilityTabBar: UITabBar!
    @IBOutlet weak var drawButton: UITabBarItem!
    @IBOutlet weak var stickerButton: UITabBarItem!
    @IBOutlet weak var fontButton: UITabBarItem!
    @IBOutlet weak var filterButton: UITabBarItem!
    @IBOutlet weak var originalImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    var imageFromCamera:UIImage? = nil
    var photoTakenDelegate:PhotoTakenDelegate? = nil
    var photoUtilityContainerViewController:PhotoUtilityContainerViewController? = nil
    
    var touchesFromOtherControllerDelegate = TouchesFromOtherControllerDelegate?()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filterButton.setupFontAwesome("fa-filter")
        drawButton.setupFontAwesome("fa-paint-brush")
        fontButton.setupFontAwesome("fa-font")
        stickerButton.setupFontAwesome("fa-picture-o")
        cancelButton.setupFontAwesome("fa-times", tapAction: UITapGestureRecognizer(target: self, action: Selector("cancelTapped")))
        confirmButton.setupFontAwesome("fa-check", tapAction: UITapGestureRecognizer(target: self, action: Selector("confirmTapped")))
        
        originalImageView.image = imageFromCamera!
        
        utilityTabBar.delegate = self
        utilityTabBar.selectedItem = filterButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        filterTapped()
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.title!{
            case "filter":
                filterTapped()
                break
            case "draw":
                drawingTapped()
                break;
            case "write":
                fontTapped();
                break;
            case "sticker":
                stickerTapped()
                break;
            default:
                break;
        }
    }
    

    
    func setupBarButton(barButtonItem:UIBarButtonItem, fontAwesomeName: String, tapAction: String){
        barButtonItem.image = UIImage.fontAwesomeIconWithName(FontAwesome(rawValue: FontAwesomeIcons[fontAwesomeName]!)!, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        barButtonItem.action = Selector(tapAction)
        barButtonItem.target = self
    }
    
    func filterTapped(){
        photoUtilityContainerViewController!.performSegue("filtersChildSegue")
    }
    
    func drawingTapped(){
        photoUtilityContainerViewController!.performSegue("drawingChildSegue")
    }
    
    func fontTapped(){
        photoUtilityContainerViewController!.performSegue("fontChildSegue")
    }
    
    func stickerTapped(){
        photoUtilityContainerViewController!.performSegue("stickersChildSegue")
    }
    
    func confirmTapped(){
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, true, 0.0)
        containerView.drawViewHierarchyInRect(containerView.bounds, afterScreenUpdates: false)
        let editedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        photoTakenDelegate?.photoTaken(editedImage)
        
        performSegueWithIdentifier("backToNewRemnantSegue", sender: self)
    }
    
    func cancelTapped(){
        performSegueWithIdentifier("backToNewRemnantSegue", sender: self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchesFromOtherControllerDelegate?.touchesBeganInOtherController(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchesFromOtherControllerDelegate?.touchesMovedInOtherController(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchesFromOtherControllerDelegate?.touchesEndedInOtherController(touches, withEvent: event)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "photoContainerEmbedSegue"){
            photoUtilityContainerViewController = segue.destinationViewController as? PhotoUtilityContainerViewController
            photoUtilityContainerViewController!.container = self
        }
    }
    

}
