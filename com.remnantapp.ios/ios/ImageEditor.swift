/*--------------------------
- PikLab -

created by FV iMAGINATION ©2015
for CodeCanyon.net

All rights reserved
----------------------------*/

import UIKit

import AudioToolbox
import CoreImage



class ImageEditor: UIViewController,
    UIAlertViewDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    UITextViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    
    /* Views */
    @IBOutlet weak var toolbarView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var originalImage: UIImageView!
    
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var watermarkLabel: UILabel!
    
    // Keyboard Toolbar View
    var keyboardToolbar: UIView = UIView(frame: CGRectMake(0, 0, 0, 0))
    
    // TextView for text
    @IBOutlet weak var txtView: UITextView!
    

    var firstload = true
    var photoAddedDelegate = PhotoAddedDelegate?()
    
    
    
    // HIDE STATUS BAR
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setEverythingUpYall(){
        // Get the cropped Image
        originalImage.image = croppedImage
        
        // Set the image for filters as the Original image
        imageForFilters.image = croppedImage
        
        
        // Move the Tool Views out of the screen
        fontsView.frame.origin.y      = view.frame.size.height
        stickersView.frame.origin.y   = view.frame.size.height
        texturesView.frame.origin.y   = view.frame.size.height
        bordersView.frame.origin.y    = view.frame.size.height
        filtersView.frame.origin.y    = view.frame.size.height
        adjustmentView.frame.origin.y = view.frame.size.height
        
        
        // SETUP IMAGE EDITOR TOOLS:
        dispatch_async(dispatch_get_main_queue(), {
            self.setupTextTool()
            self.setupStickersTool()
            self.setupTexturesTool()
            self.setupBordersTool()
            self.setupFiltersTool()
            
            self.txtView.frame = self.imageForFilters.frame
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        self.setEverythingUpYall()
    }
    
    override func viewDidAppear(animated: Bool) {

        
        super.viewDidAppear(false)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        dismissViewControllerAnimated(false, completion: nil)
        
        //spinner.startAnimating()
        
        dispatch_async(dispatch_get_main_queue(), {
            croppedImage = image.imageRotatedByDegrees(90, flip: false)
            //croppedImage = image
            self.setEverythingUpYall()
            //self.spinner.stopAnimating()
        })
    }
    
    // MARK - ADMOB INTERSTITIAL
    func showInterstitial() {
        // Show AdMob interstitial
        
    }
    
    
    
    
    
    // MARK: -  CANCEL EDITING BUTTON
    @IBAction func cancelButt(sender: AnyObject) {
        let alert = UIAlertView(title: APP_NAME,
            message: "Are you sure you want to exit? \nYou'll lose all the changes you've made so far",
            delegate: self,
            cancelButtonTitle: "No",
            otherButtonTitles: "Exit")
        alert.show()
    }
    // AlertView delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.buttonTitleAtIndex(buttonIndex) == "Exit" {
            //let mainVC = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreen") as! MainScreen
            //mainVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            //presentViewController(mainVC, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - SAVE IMAGE BUTTON
    @IBAction func saveImageButt(sender: AnyObject) {
        renderEditedImage()
        
        //photoAddedDelegate?.photoAdded(editedImage!)
        dismissViewControllerAnimated(false, completion: nil)
        return
        

        
    }
    
    
    // MARK: -  RENDER THE EDITED IMAGE
    func renderEditedImage() {
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, true, 0.0)
        containerView.drawViewHierarchyInRect(containerView.bounds, afterScreenUpdates: false)
        //editedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    /* TOOL BUTTONS ======*/
    @IBAction func textToolButt(sender: AnyObject) {
        showFontsView()
    }
    @IBAction func stickersToolButt(sender: AnyObject) {
        showStickersView()
    }
    @IBAction func texturesToolButt(sender: AnyObject) {
        showTexturesView()
    }
    @IBAction func bordersToolButt(sender: AnyObject) {
        showBordersView()
    }
    @IBAction func filtersToolButt(sender: AnyObject) {
        showFiltersView()
    }
    
    @IBAction func adjustmentButt(sender: AnyObject) {
        showAdjustmentView()
        hideAdjustmentSliders()
    }
    // Hide Adjustment Sliders when they're not used
    func hideAdjustmentSliders() {
        brightnessSlider.hidden = true
        contrastSlider.hidden = true
        saturationSlider.hidden = true
        exposureSlider.hidden = true
        brightnessOutlet.backgroundColor = lightBlack
        contrastOutlet.backgroundColor = lightBlack
        saturationOutlet.backgroundColor = lightBlack
        exposureOutlet.backgroundColor = lightBlack
        
    }
    
    
    
    
    
    
    // MARK: -  TEXT TOOL -----------------
    
    /*Variables */
    var textIsVisible = true
    
    /* Views */
    @IBOutlet weak var fontsView: UIView!
    @IBOutlet weak var fontsTableView: UITableView!
    @IBOutlet weak var opacityFontSlider: UISlider!
    
    // Colors ScrollView
    var colorScrollView: UIScrollView = UIScrollView(frame: CGRectMake(0, 0, 0, 0))
    var colorButt: UIButton?
    var colorTag = 0
    
    
    
    
    func setupTextTool() {
        
        // TxtView settings
        txtView.delegate = self
        txtView.inputAccessoryView = keyboardToolbar
        
        
        // Keyboard Toolbar settings
        keyboardToolbar.backgroundColor = UIColor(red: 31.0/255.0, green: 37.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        keyboardToolbar.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        keyboardToolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        
        
        // LEFT Alignment button
        let leftButt: UIButton = UIButton(type: UIButtonType.Custom)
        leftButt.frame = CGRectMake(0, 0, 44, 44)
        leftButt.setBackgroundImage(UIImage(named: "left"), forState: UIControlState.Normal)
        leftButt.addTarget(self, action: "leftTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        keyboardToolbar.addSubview(leftButt)
        
        // CENTER Alignment button
        let centerButt: UIButton = UIButton(type: UIButtonType.Custom)
        centerButt.frame = CGRectMake(leftButt.frame.origin.x+54, 0, 44, 44)
        centerButt.setBackgroundImage(UIImage(named: "center"), forState: UIControlState.Normal)
        centerButt.addTarget(self, action: "centerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        keyboardToolbar.addSubview(centerButt)
        
        // RIGHT Alignment button
        let rightButt: UIButton = UIButton(type: UIButtonType.Custom)
        rightButt.frame = CGRectMake(centerButt.frame.origin.x+54, 0, 44, 44)
        rightButt.setBackgroundImage(UIImage(named: "right"), forState: UIControlState.Normal)
        rightButt.addTarget(self, action: "rightTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        keyboardToolbar.addSubview(rightButt)
        
        // COLORS ScrollView (to color the text)
        colorScrollView.frame = CGRectMake(rightButt.frame.origin.x+54, 0, keyboardToolbar.frame.size.width - 142 - 58, 44)
        colorScrollView.backgroundColor = UIColor.clearColor()
        colorScrollView.userInteractionEnabled = true
        colorScrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        keyboardToolbar.addSubview(colorScrollView)
        
        
        // DISMISS KEYBOARD button
        let dismissButt: UIButton = UIButton(type: UIButtonType.Custom)
        dismissButt.frame = CGRectMake(keyboardToolbar.frame.size.width-44, 0, 44, 44)
        dismissButt.setBackgroundImage(UIImage(named: "okCropButt"), forState: UIControlState.Normal)
        dismissButt.addTarget(self, action: "dismissKeyboard:", forControlEvents: UIControlEvents.TouchUpInside)
        keyboardToolbar.addSubview(dismissButt)
        
        
        
        // Resize fontsTableView
        fontsTableView.frame.size.height = 160
        
        // Setup Text Colors Menu
        setupTextColorsMenu()
    }
    
    
    
    
    
    // MARK: - FONTS TABLEVIEW DELEGATES
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Cell")
        
        // Cell settings ========
        cell.contentView.backgroundColor = UIColor.blackColor()
        cell.textLabel!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        cell.textLabel!.textAlignment = NSTextAlignment.Center
        cell.textLabel!.font = UIFont(name: fontList[indexPath.row], size: 17)
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.text = fontList[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - FONT SELECTED
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        txtView.font = UIFont(name: fontList[indexPath.row], size: 26)
    }
    
    
    
    
    // Show/Hide Text button
    @IBOutlet weak var hideTxtOutlet: UIButton!
    @IBAction func hideTxtButt(sender: AnyObject) {
        textIsVisible = !textIsVisible
        print("textVisible: \(textIsVisible)")
        
        if textIsVisible {
            txtView.hidden = false
            hideTxtOutlet.setBackgroundImage(UIImage(named: "hideTxtButt"), forState: UIControlState.Normal)
        } else {
            txtView.hidden = true
            hideTxtOutlet.setBackgroundImage(UIImage(named: "showTxtButt"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func dismissFontsButt(sender: AnyObject) {
        hideFontsView()
    }
    
    
    @IBAction func opacityFontChanged(sender: UISlider) {
        txtView.alpha = CGFloat(sender.value)
    }
    
    
    func dismissKeyboard(sender: AnyObject) {
        txtView.resignFirstResponder()
    }
    
    
    
    
    // MARK: - SETUP TEXT COLORS MENU
    func setupTextColorsMenu() {
        // Variables for setting the Color Buttons
        var xCoord: CGFloat = 0
        let yCoord: CGFloat = 8
        let buttonWidth:CGFloat = 40
        let buttonHeight: CGFloat = 28
        let gap: CGFloat = 0
        
        // Counter for Colors
        var colorsCount = 0
        
        // Loop for creating buttons -------------------------------------------
        for colorsCount = 0;  colorsCount < colorList.count;  colorsCount++  {
            colorTag = colorsCount
            
            // Create a Button
            colorButt = UIButton(type: UIButtonType.Custom)
            colorButt?.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
            colorButt?.tag = colorTag
            colorButt?.backgroundColor = colorList[colorsCount]
            colorButt?.showsTouchWhenHighlighted = false
            colorButt?.addTarget(self, action: "colorButtTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            
            xCoord +=  buttonWidth + gap
            colorScrollView.addSubview(colorButt!)
        } // END LOOP -------------------------------------------------
        
        
        // Place Buttons into the ScrollView
        colorScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(colorsCount), yCoord)
    }
    
    func colorButtTapped(sender: AnyObject) {
        txtView.textColor = sender.backgroundColor
        resetTxtViewFrame()
    }
    
    
    // MARK: - ALIGNMENT BUTTONS
    func leftTapped(sender: AnyObject) {
        txtView.textAlignment = NSTextAlignment.Left
    }
    func rightTapped(sender: AnyObject) {
        txtView.textAlignment = NSTextAlignment.Right
    }
    func centerTapped(sender: AnyObject) {
        txtView.textAlignment = NSTextAlignment.Center
    }
    
    
    /* TEXT VIEW DELEGATES ============*/
    func textViewDidChange(textView: UITextView) {
        resetTxtViewFrame()
    }
    func textViewDidBeginEditing(textView: UITextView) {
        if txtView.text == "TAP TO EDIT TEXT" {
            txtView.text = ""
        }
        txtView.becomeFirstResponder()
        
        // Hide all Tool Views
        hideStickersView()
    }
    
    /* GESTURE RECOGNIZERS ON TEXT VIEW ========================*/
    @IBAction func scaleTxtView(sender: UIPinchGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended ||
            sender.state == UIGestureRecognizerState.Changed {
                let currentScale: CGFloat = CGFloat(txtView.frame.size.width / txtView.bounds.size.width)
                var newScale: CGFloat = CGFloat(currentScale * sender.scale)
                
                if newScale < 0.8 {
                    newScale = 0.8
                }
                if newScale > 1.3 {
                    newScale = 1.3
                }
                
                let transform: CGAffineTransform = CGAffineTransformMakeScale(newScale, newScale)
                CGAffineTransformMakeScale(newScale, newScale);
                txtView.transform = transform
                sender.scale = 1
        }
    }
    
    @IBAction func moveTxtView(sender: UIPanGestureRecognizer) {
        let translation: CGPoint =  sender.translationInView(self.view)
        sender.view?.center = CGPointMake(sender.view!.center.x +  translation.x, sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointMake(0, 0), inView: self.view)
    }
    
    
    // Reset the TextView frame
    func resetTxtViewFrame() {
        let fixedWidth = CGFloat(txtView.frame.size.width)
        let maxFloat = CGFloat(MAXFLOAT)
        let newSize:CGSize = txtView.sizeThatFits(CGSizeMake(fixedWidth, maxFloat))
        var newFrame:CGRect = txtView.frame
        newFrame.size = CGSizeMake(fmax(newSize.width, fixedWidth), newSize.height)
        txtView.frame = newFrame
        
        print("txtFrame: \(newFrame)")
    }
    
    
    /* Hide/Show Fonts View */
    func showFontsView() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.fontsView.frame.origin.y = self.containerView.frame.height
            }, completion: { (finished: Bool) in
        })
    }
    func hideFontsView() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.fontsView.frame.origin.y = self.view.frame.size.height
            }, completion: { (finished: Bool) in
        })
    }
    
    
    
    
    
    
    
    
    // MARK: - STICKERS TOOL -------------------
    
    /* Variables */
    var stickerTAG = 0
    
    /* VIEWS */
    @IBOutlet weak var stickersView: UIView!
    @IBOutlet weak var stickersScrollView: UIScrollView!
    var stickerButt: UIButton?
    
    
    
    func setupStickersTool() {
        // Variables for setting the Font Buttons
        var xCoord: CGFloat = 10
        let yCoord: CGFloat = 10
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 10
        
        // Counter for Fonts
        var itemCount = 0
        
        // Loop for creating buttons
        for itemCount = 0; itemCount < 11+1; ++itemCount {
            stickerTAG = itemCount
            
            // Create a Button for each Sticker
            stickerButt = UIButton(type: UIButtonType.Custom)
            stickerButt?.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
            stickerButt?.tag = stickerTAG
            stickerButt?.showsTouchWhenHighlighted = true
            stickerButt?.setImage(UIImage(named: "s\(stickerTAG)"), forState: UIControlState.Normal)
            stickerButt?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            stickerButt?.addTarget(self, action: "stickerButtTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            stickerButt?.layer.borderWidth = 1
            stickerButt?.layer.borderColor = UIColor.darkGrayColor().CGColor
            // stickerButt?.layer.cornerRadius = 8
            stickerButt?.clipsToBounds = true
            
            // Add Buttons & Labels based on xCood
            xCoord +=  buttonWidth + gapBetweenButtons
            stickersScrollView.addSubview(stickerButt!)
        } // END LOOP
        
        
        // Place Buttons into the ScrollView =====
        let itemCountFloat = CGFloat(Int(itemCount))
        stickersScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(itemCountFloat+2), yCoord)
        
    }
    
    var stickerImg: UIImageView?
    
    var stickersTAGArray = [Int]()
    var sndrTAG = 0
    
    func stickerButtTapped(sender: AnyObject) {
        sndrTAG = 100
        print("sndrTAG: \(sndrTAG)")
        
        stickerImg = UIImageView(frame: CGRectMake(0, 0, 200, 200))
        stickerImg?.center = CGPointMake(containerView.frame.size.width/2, containerView.frame.size.height/2)
        stickerImg?.backgroundColor = UIColor.clearColor()
        stickerImg?.image = UIImage(named: "s\(sender.tag)")
        stickerImg?.tag = sndrTAG
        stickerImg?.userInteractionEnabled = true
        stickerImg?.multipleTouchEnabled = true
        containerView.addSubview(stickerImg!)
        
        // Add an array of stickers
        stickersTAGArray.append(stickerImg!.tag)
        print("stickersTAGArray:\(stickersTAGArray)")
        
        
        // Add PAN GESTURES to the sticker
        let panGestSticker = UIPanGestureRecognizer()
        panGestSticker.addTarget(self, action: "moveSticker:")
        stickerImg!.addGestureRecognizer(panGestSticker)
        
        // Add DOUBLE TAP GESTURES to the sticker
        let doubletapGestSticker = UITapGestureRecognizer()
        doubletapGestSticker.addTarget(self, action: "deleteSticker:")
        doubletapGestSticker.numberOfTapsRequired = 2
        stickerImg!.addGestureRecognizer(doubletapGestSticker)
        
        // Add PINCH GESTURES to the sticker
        let pinchGestSticker = UIPinchGestureRecognizer()
        pinchGestSticker.addTarget(self, action: "zoomSticker:")
        stickerImg!.addGestureRecognizer(pinchGestSticker)
        
        
        // Add ROTATION GESTURES to the sticker
        let rotationGestSticker = UIRotationGestureRecognizer()
        rotationGestSticker.addTarget(self, action: "rotateSticker:")
        stickerImg!.addGestureRecognizer(rotationGestSticker)
        
        
    }
    // MOVE STICKER
    func moveSticker(sender: UIPanGestureRecognizer) {
        let translation: CGPoint =  sender.translationInView(self.view)
        sender.view?.center = CGPointMake(sender.view!.center.x +  translation.x, sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointMake(0, 0), inView: self.view)
    }
    // DELETE STICKER (with a double-tap on a sticker
    func deleteSticker(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        
        stickersTAGArray.removeLast()
        //println("stkrTAGArray2:\(stickersTAGArray)")
    }
    // ZOOM STICKER
    func zoomSticker(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 1
    }
    // ROTATE STICKER
    func rotateSticker(sender:UIRotationGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Began ||
            sender.state == UIGestureRecognizerState.Changed
        {
            sender.view!.transform = CGAffineTransformRotate(sender.view!.transform, sender.rotation)
            sender.rotation = 0
        }
    }
    
    
    
    @IBAction func dismissStickersButt(sender: AnyObject) {
        hideStickersView()
    }
    
    // Show/Hide Stickers View ======
    func showStickersView() {
        self.stickersView.hidden = false
//        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
//            self.stickersView.frame.origin.y = self.buttonsView.frame.origin.y
//            }, completion: { (finished: Bool) in
//        })
    }
    func hideStickersView() {
        self.stickersView.hidden = true
//        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
//            self.stickersView.frame.origin.y = self.view.frame.size.height
//            }, completion: { (finished: Bool) in
//        })
    }
    
    
    
    
    
    
    
    
    // MARK: - TEXTURES TOOL ----------------------------
    
    /* Variables */
    var textureTAG = 0
    
    /* Views */
    @IBOutlet weak var texturesView: UIView!
    @IBOutlet weak var texturesScrollView: UIScrollView!
    var textureButt = UIButton()
    @IBOutlet weak var textureAlphaSlider: UISlider!
    
    
    func setupTexturesTool() {
        // Variables for setting the Buttons
        var xCoord: CGFloat = 10
        let yCoord: CGFloat = 0
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 10
        
        // Counter for Textures
        var itemCount = 0
        
        // Loop for creating buttons
        for itemCount = 0; itemCount < 9+1; ++itemCount {
            textureTAG = itemCount
            
            // Create a Button for each Texture ==========
            textureButt = UIButton(type: UIButtonType.Custom)
            textureButt.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
            textureButt.tag = textureTAG
            textureButt.showsTouchWhenHighlighted = true
            textureButt.setImage(UIImage(named: "t\(textureTAG)"), forState: UIControlState.Normal)
            textureButt.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            textureButt.addTarget(self, action: "textureButtTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            textureButt.layer.borderWidth = 1
            textureButt.layer.borderColor = UIColor.darkGrayColor().CGColor
            // textureButt?.layer.cornerRadius = 8
            textureButt.clipsToBounds = true
            
            
            // Add Buttons & Labels based on xCood
            xCoord +=  buttonWidth + gapBetweenButtons
            texturesScrollView.addSubview(textureButt)
        } // END LOOP =========================================
        
        
        // Place Buttons into the ScrollView =====
        let itemCountFloat = CGFloat(Int(itemCount))
        texturesScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(itemCountFloat+2), yCoord)
        
    }
    
    var textureImg: UIImageView?
    
    func textureButtTapped(sender: AnyObject) {
        if (textureImg != nil) {
            textureImg?.removeFromSuperview()
        }
        
        textureImg = UIImageView(frame: CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height))
        textureImg?.center = CGPointMake(containerView.frame.size.width/2, containerView.frame.size.height/2)
        textureImg?.backgroundColor = UIColor.clearColor()
        textureImg?.image = UIImage(named: "t\(sender.tag)")
        // println("textureTAG= \(sender.tag)")
        textureImg?.userInteractionEnabled = true
        textureImg?.multipleTouchEnabled = true
        textureImg?.alpha = CGFloat(textureAlphaSlider.value)
        containerView.addSubview(textureImg!)
        
        if sender.tag == 0 {
            textureImg?.removeFromSuperview()
        }
        
        
        // Bring Borders, Text and Stickers to FRONT ============
        if borderImg != nil {
            containerView.bringSubviewToFront(borderImg!)
        }
        if txtView != nil {
            containerView.bringSubviewToFront(txtView)
        }
        if stickerImg != nil {
            for var stkrCount = 0; stkrCount < stickersTAGArray.count; stkrCount++ {
                let viewTAG = stickersTAGArray[stkrCount]
                containerView.bringSubviewToFront(self.view.viewWithTag(viewTAG)! )
            }
        }
        // Bring PhotoLab watermark to FRONT
        containerView.bringSubviewToFront(watermarkLabel)
    }
    
    // Texture opacity Slider
    @IBAction func textureAlphaChanged(sender: UISlider) {
        textureImg?.alpha = CGFloat(sender.value)
    }
    
    // Rotate Texture Button
    @IBAction func rotateTextureButt(sender: AnyObject) {
        if textureImg == nil {
            return
        }
        
        textureImg?.transform = CGAffineTransformRotate(textureImg!.transform, CGFloat (M_PI_2))
    }
    
    // Dismiss texturesView Button
    @IBAction func dismissTexturesView(sender: AnyObject) {
        hideTexturesView()
    }
    
    
    // Show/Hide Textures View =====================
    func showTexturesView() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.texturesView.frame.origin.y = self.buttonsView.frame.origin.y
            }, completion: { (finished: Bool) in
        })
    }
    func hideTexturesView() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.texturesView.frame.origin.y = self.view.frame.size.height
            }, completion: { (finished: Bool) in
        })
    }
    
    
    
    
    
    
    
    
    
    // MARK: - BODERS TOOL ------------------
    /* Variables */
    var borderTAG = 0
    
    /* Views */
    @IBOutlet weak var bordersView: UIView!
    @IBOutlet weak var bordersScrollView: UIScrollView!
    var borderButt = UIButton()
    @IBOutlet weak var borderAlphaSlider: UISlider!
    
    @IBOutlet weak var borderColorsScrollView: UIScrollView!
    var colorBorderButt: UIButton?
    
    var borderImg: UIImageView?
    
    
    func setupBordersTool() {
        // Variables for setting the Buttons
        var xCoord: CGFloat = 10
        let yCoord: CGFloat = 0
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 10
        
        // Counter for Borders
        var itemCountB = 0
        
        // Loop for creating buttons =========================
        for itemCountB = 0; itemCountB < 9+1; ++itemCountB {
            borderTAG = itemCountB
            
            // Create a Button for each Texture ==========
            borderButt = UIButton(type: UIButtonType.Custom)
            borderButt.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
            borderButt.tag = borderTAG
            borderButt.showsTouchWhenHighlighted = true
            borderButt.setImage(UIImage(named: "b\(borderTAG)"), forState: UIControlState.Normal)
            borderButt.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            borderButt.addTarget(self, action: "borderButtTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            borderButt.layer.borderWidth = 1
            borderButt.layer.borderColor = UIColor.darkGrayColor().CGColor
            // borderButt?.layer.cornerRadius = 8
            borderButt.clipsToBounds = true
            
            // Add Buttons & Labels based on xCood
            xCoord +=  buttonWidth + gapBetweenButtons
            bordersScrollView.addSubview(borderButt)
        } // END LOOP =========================================
        
        
        // Place Buttons into the ScrollView =====
        bordersScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(itemCountB+2), yCoord)
        
        // Setup the colors menu for Borders
        setupBorderColorsMenu()
    }
    
    
    func borderButtTapped(sender: AnyObject) {
        if (borderImg != nil) {  borderImg?.removeFromSuperview() }
        
        borderImg = UIImageView(frame: CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height))
        borderImg?.backgroundColor = UIColor.clearColor()
        borderImg?.image = UIImage(named: "b\(sender.tag)")
        borderImg?.userInteractionEnabled = true
        borderImg?.multipleTouchEnabled = true
        borderImg?.alpha = CGFloat(borderAlphaSlider.value)
        containerView.addSubview(borderImg!)
        
        
        // Remove Border when empty button is selected
        if sender.tag == 0 {
            borderImg?.removeFromSuperview()
        }
        
        // Add PINCH GESTURES to the selected Border
        let pinchGestBorder = UIPinchGestureRecognizer()
        pinchGestBorder.addTarget(self, action: "zoomBorder:")
        borderImg!.addGestureRecognizer(pinchGestBorder)
        
        
        // Bring Text and Stickers to FRONT
        if txtView != nil {
            containerView.bringSubviewToFront(txtView)
        }
        if stickerImg != nil {
            for var stkrCount = 0; stkrCount < stickersTAGArray.count; stkrCount++
            {
                let viewTAG = stickersTAGArray[stkrCount]
                containerView.bringSubviewToFront(self.view.viewWithTag(viewTAG)! )
            }
        }
        // Bring PhotoLab watermark to FRONT
        containerView.bringSubviewToFront(watermarkLabel)
    }
    
    
    // ZOOM BORDER
    func zoomBorder(sender: UIPinchGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended ||
            sender.state == UIGestureRecognizerState.Changed {
                let currentScale: CGFloat = CGFloat(borderImg!.frame.size.width / borderImg!.bounds.size.width)
                var newScale: CGFloat = CGFloat(currentScale * sender.scale)
                
                //Constrain zoom to specific scale ratios
                if newScale < 1.0 {
                    newScale = 1.0
                }
                if newScale > 1.4 {
                    newScale = 1.4
                }
                let transform: CGAffineTransform = CGAffineTransformMakeScale(newScale, newScale)
                CGAffineTransformMakeScale(newScale, newScale);
                borderImg!.transform = transform
                sender.scale = 1
        }
    }
    
    
    // Setup Colors for Borders Tool
    func setupBorderColorsMenu() {
        // Variables for setting the Color Buttons
        var xCoord: CGFloat = 0
        let yCoord: CGFloat = 3
        let buttonWidth:CGFloat = 34
        let buttonHeight: CGFloat = 34
        let gapBetweenButtons: CGFloat = 0
        
        borderColorsScrollView.frame.size.width = view.frame.size.width - 170
        
        // Counter for Colors
        var colorsCount = 0
        
        // Loop for creating buttons ========
        for colorsCount = 0; colorsCount < colorList.count; ++colorsCount {
            colorTag = colorsCount
            
            // Create a Button for each Color ==========
            colorBorderButt = UIButton(type: UIButtonType.Custom)
            colorBorderButt?.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
            colorBorderButt?.tag = colorTag  // Assign a tag to each button
            colorBorderButt?.backgroundColor = colorList[colorsCount]
            colorBorderButt?.showsTouchWhenHighlighted = false
            colorBorderButt?.addTarget(self, action: "colorBorderButtTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            
            xCoord +=  buttonWidth + gapBetweenButtons
            borderColorsScrollView.addSubview(colorBorderButt!)
        } // END LOOP ================================
        
        
        // Place Buttons into the ScrollView
        borderColorsScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(colorsCount), yCoord)
    }
    func colorBorderButtTapped(sender: AnyObject) {
        borderImg?.image = borderImg?.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        borderImg?.tintColor = sender.backgroundColor
    }
    
    
    
    // Border opacity slider
    @IBAction func borderAlphaChanged(sender: UISlider) {
        borderImg?.alpha = CGFloat(sender.value)
    }
    
    @IBAction func dismissBordersView(sender: AnyObject) {
        hideBordersView()
    }
    
    
    // Show/Hide Borders View
    func showBordersView() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.bordersView.frame.origin.y = self.buttonsView.frame.origin.y
            }, completion: { (finished: Bool) in
        })
    }
    func hideBordersView() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.bordersView.frame.origin.y = self.view.frame.size.height
            }, completion: { (finished: Bool) in
        })
    }
    
    
    
    
    
    
    
    
    // MARK: - FILTERS TOOL ------------------------------------------
    
    
    /* Variables */
    var filterTAG = 0
    
    /* Views */
    @IBOutlet weak var imageForFilters: UIImageView!
    
    @IBOutlet weak var filtersView: UIView!
    @IBOutlet weak var filtersScrollView: UIScrollView!
    var filterButt: UIButton?
    
    
    // Filters List & Names ------------------------
    let filtersList = [
        "None",                    //0
        "CIVignette",              //1
        "CIPhotoEffectInstant",    //2
        "CIPhotoEffectProcess",    //3
        "CIPhotoEffectTransfer",   //4
        "CISepiaTone",             //5
        "CIPhotoEffectChrome",     //6
        "CIPhotoEffectFade",       //7
        "CIPhotoEffectTonal",      //8
        "CIPhotoEffectNoir",       //9
        "CIMaximumComponent",      //10
        "CIMinimumComponent",      //11
        "CIDotScreen",             //12
        "CIColorMonochrome",       //13
        "CIColorMonochrome",       //14
        "CIColorMonochrome",       //15
        "CIColorPosterize",        //16
        "CISharpenLuminance",      //17
        "CIGammaAdjust",           //18
        "CIHueAdjust",             //19
        "CIHueAdjust",             //20
        "CIHueAdjust",             //21
        "CISepiaTone",             //22
        
        // Add here new CIFilters...
    ]
    
    let filterNamesList = [
        "None",        //0
        "Vignette",    //1
        "Imagine",     //2
        "Retro",       //3
        "Chic",        //4
        "Sepia",       //5
        "Light",       //6
        "Aqua",        //7
        "Tonal",       //8
        "Noir",        //9
        "Darken",      //10
        "Rude",        //11
        "Dotted",      //12
        "Orange",      //13
        "Reddy",       //14
        "Canary",      //15
        "Poster",      //16
        "Sharp",       //17
        "Boris",       //18
        "Marylin",     //19
        "Fantik",      //20
        "Ipse",        //21
        "Vintiq",      //22
        
        //Set new Filter Names here...
        
    ]
    //-------------------------------------------
    
    
    
    
    func setupFiltersTool() {
        // Variables for setting the Buttons
        var xCoord: CGFloat = 10
        let yCoord: CGFloat = 10
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 10
        
        // Counter for Filters
        var itemCount = 0
        
        // Loop for creating buttons =========================
        for itemCount = 0; itemCount < filtersList.count; ++itemCount {
            filterTAG = itemCount
            
            // Create a Button for each Texture ==========
            filterButt = UIButton(type: UIButtonType.Custom)
            filterButt?.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
            filterButt?.tag = filterTAG
            filterButt?.showsTouchWhenHighlighted = true
            filterButt?.setImage(UIImage(named: "f\(filterTAG)"), forState: UIControlState.Normal)
            filterButt?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            filterButt?.addTarget(self, action: "filterButtTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            filterButt?.layer.borderWidth = 1
            filterButt?.layer.borderColor = UIColor.darkGrayColor().CGColor
            // filterButt?.layer.cornerRadius = 8
            filterButt?.clipsToBounds = true
            
            // Add a Label that shows Filter Name =========
            let filterLabel: UILabel = UILabel()
            filterLabel.frame = CGRectMake(0, filterButt!.frame.size.height-15, buttonWidth, 15)
            filterLabel.backgroundColor = UIColor.blackColor()
            filterLabel.alpha = 0.8
            filterLabel.textColor = UIColor.whiteColor()
            filterLabel.textAlignment = NSTextAlignment.Center
            filterLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 10)
            filterLabel.text = "\(filterNamesList[itemCount])"
            filterButt?.addSubview(filterLabel)
            
            
            // Add Buttons & Labels based on xCood
            xCoord +=  buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButt!)
        } // END LOOP =========================================
        
        
        // Place Buttons into the ScrollView =====
        let itemCountFloat = CGFloat(Int(itemCount))
        filtersScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(itemCountFloat+4), yCoord)
    }
    
    func filterButtTapped(button: UIButton) {
        
        // Remove adjImage (if any)
        adjImage?.image = nil
        
        // Reset the Adjustment Tools
        brightnessSlider.value = 0
        contrastSlider.value = 1
        saturationSlider.value = 1
        exposureSlider.value = 0.5
        
        
        // Set the filteredImage as the Original image
        imageForFilters.image = originalImage.image
        
        if button.tag == 0 {
            // NO Filter (go back to Original image)
            imageForFilters.image = originalImage.image
        } else {
            
            
            
            
            // MARK: - FILTER SETTINGS ------------------------------------
            
            let CIfilterName = "\(filtersList[button.tag])"
            print("\(CIfilterName)")
            
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: imageForFilters.image!)
            let filter = CIFilter(name: CIfilterName)
            filter!.setDefaults()
            
            
            switch button.tag {
                
            case 1: // Vignette
                filter!.setValue(3.0, forKey: kCIInputRadiusKey)
                filter!.setValue(4.0, forKey: kCIInputIntensityKey)
                break
                
            case 13: // Orangy
                let color:UIColor = UIColor(red: 247/255.0, green: 174/255.0, blue: 71/255.0, alpha: 1.0)
                filter!.setValue(CIColor(color: color), forKey: kCIInputColorKey)
                filter!.setValue(0.8, forKey: kCIInputIntensityKey)
                break
                
            case 14: // Red X
                let color:UIColor = UIColor(red: 201/255.0, green: 91/255.0, blue: 96/255.0, alpha: 1.0)
                filter!.setValue(CIColor(color: color), forKey: kCIInputColorKey)
                filter!.setValue(0.8, forKey: kCIInputIntensityKey)
                break
                
            case 15: // Canary
                let color:UIColor = UIColor(red: 241/255.0, green: 247/255.0, blue: 71/255.0, alpha: 1.0)
                filter!.setValue(CIColor(color: color), forKey: kCIInputColorKey)
                filter!.setValue(0.8, forKey: kCIInputIntensityKey)
                break
                
            case 16: //Poster
                filter!.setValue(6.0, forKey: "inputLevels")
                break
                
            case 17: // Sharp
                filter!.setValue(0.9, forKey: kCIInputSharpnessKey)
                break
                
            case 18: //Dark
                filter!.setValue(3, forKey: "inputPower")
                break
                
            case 19: //Tint 1
                filter!.setValue(3.10, forKey: kCIInputAngleKey)
                break
                
            case 20: //Tint 2
                filter!.setValue(2.00, forKey: kCIInputAngleKey)
                break
                
            case 21: //Tint 3
                filter!.setValue(1.00, forKey: kCIInputAngleKey)
                break
                
            case 22: //Vintage
                filter!.setValue(0.5, forKey:"inputIntensity")
                break
                
                
                /* You can add new filters settings here,
                Check Core Image Filter Reference here: https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html
                */
                
                
            default: break }
            
            
            // Log the Filters attributes in the XCode console
            // println("\(filter.attributes())")
            
            // Finalize the filtered image ==========
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.valueForKey(kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
            
            imageForFilters.image = UIImage(CGImage: filteredImageRef);
        } // END FILTER SETTINGS
    }
    
    
    // DISMISS FILTERS VIEW
    @IBAction func dismissFiltersViewButt(sender: AnyObject) {
        hideFiltersView()
    }
    
    // Show/Hide Filters View ==========
    func showFiltersView() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.filtersView.frame.origin.y = self.buttonsView.frame.origin.y
            }, completion: { (finished: Bool) in
        })
    }
    func hideFiltersView() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.filtersView.frame.origin.y = self.view.frame.size.height
            }, completion: { (finished: Bool) in
        })
    }
    
    
    
    
    
    
    
    
    
    // MARK: - ADJUSTMENT TOOL ---------------------
    
    /* Variables */
    let lightBlack = UIColor(red: 47.0/255.0, green: 55.0/255.0, blue: 65.0/255.0, alpha: 1.0)
    
    /* Views */
    @IBOutlet weak var adjustmentView: UIView!
    @IBOutlet weak var adjustmentLabel: UILabel!
    
    /* Adjustment Buttons */
    @IBOutlet weak var brightnessOutlet: UIButton!
    @IBOutlet weak var contrastOutlet: UIButton!
    @IBOutlet weak var saturationOutlet: UIButton!
    @IBOutlet weak var exposureOutlet: UIButton!
    
    /* Adjustment Sliders */
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var exposureSlider: UISlider!
    
    /* Adjustment Image */
    var adjImage: UIImageView?
    
    
    
    @IBAction func adjustmentButtons(sender: AnyObject) {
        
        switch (sender.tag) {
        case 0: // Brightness
            adjustmentLabel.text = "Brightness"
            
            brightnessOutlet.backgroundColor = UIColor.blackColor()
            contrastOutlet.backgroundColor = lightBlack
            saturationOutlet.backgroundColor = lightBlack
            exposureOutlet.backgroundColor = lightBlack
            
            brightnessSlider.hidden = false
            contrastSlider.hidden = true
            saturationSlider.hidden = true
            exposureSlider.hidden = true
            break
        case 1: // Contrast
            adjustmentLabel.text = "Contrast"
            
            brightnessOutlet.backgroundColor = lightBlack
            contrastOutlet.backgroundColor = UIColor.blackColor()
            saturationOutlet.backgroundColor = lightBlack
            exposureOutlet.backgroundColor = lightBlack
            
            brightnessSlider.hidden = true
            contrastSlider.hidden = false
            saturationSlider.hidden = true
            exposureSlider.hidden = true
            break
        case 2: // Saturation
            adjustmentLabel.text = "Saturation"
            
            brightnessOutlet.backgroundColor = lightBlack
            contrastOutlet.backgroundColor = lightBlack
            saturationOutlet.backgroundColor = UIColor.blackColor()
            exposureOutlet.backgroundColor = lightBlack
            
            brightnessSlider.hidden = true
            contrastSlider.hidden = true
            saturationSlider.hidden = false
            exposureSlider.hidden = true
            break
        case 3: // Exposure
            adjustmentLabel.text = "Exposure"
            
            brightnessOutlet.backgroundColor = lightBlack
            contrastOutlet.backgroundColor = lightBlack
            saturationOutlet.backgroundColor = lightBlack
            exposureOutlet.backgroundColor = UIColor.blackColor()
            
            brightnessSlider.hidden = true
            contrastSlider.hidden = true
            saturationSlider.hidden = true
            exposureSlider.hidden = false
            break
            
        default: break
        }
    }
    
    @IBAction func adjustmentChanged(sender: UISlider) {
        print("brightn: \(brightnessSlider.value)")
        print("contrast: \(contrastSlider.value)")
        print("saturat: \(saturationSlider.value)")
        print("exposure: \(exposureSlider.value)")
        
        
        if adjImage != nil {
            adjImage?.removeFromSuperview()
        }
        
        adjImage = UIImageView(frame: CGRectMake(imageForFilters.frame.origin.x, imageForFilters.frame.origin.y, imageForFilters.frame.size.width, imageForFilters.frame.size.height))
        adjImage?.image = imageForFilters.image
        
        
        // Image process =======================
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: self.adjImage!.image!)
        let filter = CIFilter(name: "CIColorControls")
        filter!.setDefaults()
        
        filter!.setValue(self.brightnessSlider.value, forKey: "inputBrightness") // -1 to 1
        filter!.setValue(self.contrastSlider.value, forKey: "inputContrast")     // 0 to 2
        filter!.setValue(self.saturationSlider.value, forKey: "inputSaturation") // 0 to 2
        
        let exposureFilter = CIFilter(name: "CIExposureAdjust")
        exposureFilter!.setDefaults()
        exposureFilter!.setValue(exposureSlider.value, forKey:"inputEV")
        
        
        // Log the Filters attributes in the XCode console
        print("\(exposureFilter!.attributes)")
        
        // Finalize the filtered image ==========
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        exposureFilter!.setValue(filter!.outputImage, forKey: kCIInputImageKey)
        
        let filteredImageData = exposureFilter!.valueForKey(kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
        self.adjImage?.image = UIImage(CGImage: filteredImageRef);
        
        self.containerView.addSubview(self.adjImage!)
        
        
        // Bring Textures, Borders, Text and Stickers to FRONT ============
        if textureImg != nil {
            containerView.bringSubviewToFront(textureImg!)
        }
        if borderImg != nil {
            containerView.bringSubviewToFront(borderImg!)
        }
        if txtView != nil {
            containerView.bringSubviewToFront(txtView)
        }
        if stickerImg != nil {
            for var stkrCount = 0; stkrCount < stickersTAGArray.count; stkrCount++ {
                let viewTAG = stickersTAGArray[stkrCount]
                containerView.bringSubviewToFront(self.view.viewWithTag(viewTAG)! )
            }
        }
        
        // Bring PhotoLab watermark to FRONT
        containerView.bringSubviewToFront(watermarkLabel)
    }
    
    
    
    // DISMISS ADJUSTMENT VIEW
    @IBAction func dismissAdjustmentViewButt(sender: AnyObject) {
        hideAdjustmentView()
    }
    
    // Show/Hide Adjustment View ==========
    func showAdjustmentView() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.adjustmentView.frame.origin.y = self.buttonsView.frame.origin.y
            }, completion: { (finished: Bool) in
        })
    }
    func hideAdjustmentView() {
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.adjustmentView.frame.origin.y = self.view.frame.size.height
            }, completion: { (finished: Bool) in
        })
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


