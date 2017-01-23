//
//  RemnantViewController.swift
//  ios
//
//  Created by System Administrator on 11/11/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit
import Parse
import PromiseKit

class RemnantViewController: UIViewController, CustomNavbarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var commentsContainerLabel: UILabel!
    @IBOutlet weak var remnantDetails: UIView!

    @IBOutlet weak var likesContainer: UIView!
    @IBOutlet weak var numberLikesLabel: UILabel!
    @IBOutlet weak var numberLikesImageView: UIImageView!
    @IBOutlet weak var dateCreatedLabel: UILabel!


    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var addToButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navbarController: NavbarView!
    @IBOutlet weak var remnantImage: UIImageView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var descLabel: UILabel!
    
    var comments:[PFObject] = []
    var commentsLoaded = false

    var remnantId:String?
    var selectedRemnant:PFObject?
    var likeActivity:PFObject?
    var numberLikes = 0
    
    var hasLoaded = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navbarController.customNavbarDelegate = self
        navbarController.titleLabel.text = "Remnant"
        navbarController.leftButton.hidden = false
        navbarController.leftButton.setTitle("Back", forState: UIControlState.Normal)
        
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        commentTextView.layer.cornerRadius = 5
        
        SpinnerUtility.initializeSpinnerInViewDidLoad(self.view)
        
        remnantDetails.hidden = true
        
        doInitialLoad()

        print("remnantViewController: viewDidLoad")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupCommentsTable()
        SpinnerUtility.initializeSpinnerInViewDidAppear(self.view)
    }
    
    func doInitialLoad(){
        SpinnerUtility.startAnimatingForView(self.view)
        
        likeButton.setupFontAwesome("fa-heart-o", title: "like", color: UIColor.redColor(), actionTarget: self, action: "likeTapped")
        locationButton.setupFontAwesome("fa-map-marker", title: "location", actionTarget: self, action: "locationTapped")
        //addToButton.setupFontAwesome("fa-plus", title: "add-to", actionTarget: self, action: "addToTapped")
        saveButton.setupFontAwesome("fa-bookmark", title: "save", actionTarget: self, action: "saveTapped")
        numberLikesImageView.setupFontAwesome("fa-heart", tapAction: nil, textColor: UIColor.darkGrayColor(), width: 10, height: 10)
        
        DataAccessLayer.getRemnantForDetailView(remnantId!).then { (returned: NSDictionary?) -> URLDataPromise in
            
            self.selectedRemnant = returned!["remnant"] as? PFObject

            dispatch_async(dispatch_get_main_queue()) {
                self.loadRemnantDetails(returned!)
            }
            
            return NSURLConnection.GET((self.selectedRemnant!["photo"] as! PFFile).url!)
            }.then({ (data:NSData) -> Void in
                self.remnantImage.image = UIImage(data: data)
                //self.view.layoutIfNeeded()
            }).always { () -> Void in
                SpinnerUtility.stopAnimatingForView(self.view)
            }.error { (error:ErrorType) -> Void in
                UIUtility.ShowAlert(self, title: "Error", message: "There was an error loading the remnant. \(error)")
        }
    }
    
    func loadRemnantDetails(returnObject:NSDictionary){
        let description:String? = self.selectedRemnant!["description"] as? String
        likeActivity = returnObject["userLikeActivity"] as! PFObject?
        let userHasSaved = returnObject["userHasSaved"] as! Bool
        let createdDate = self.selectedRemnant!.createdAt!
        
        self.dateCreatedLabel.text = createdDate.timeAgoSinceNow()
        
        
        descLabel.attributedText = getColoredText(self.selectedRemnant!["userName"] as! String, description: description, color: UIColor.blueColor())
        descLabel.sizeToFit()
        
        if(self.selectedRemnant!["likes"] != nil){
            self.numberLikes = self.selectedRemnant!["likes"] as! Int
            refreshLikes()
        }
        else{
            likesContainer.hidden = true
        }

        if(likeActivity != nil){
            likeButton.setupFontAwesome("fa-heart", title: "liked", color: UIColor.redColor())
        }
        
        if(userHasSaved){
            saveButton.setupFontAwesome("fa-bookmark", title: "saved", color: UIColor.redColor())
        }
        
        remnantDetails.hidden = false
    }
    
    func refreshLikes(){
        let likeOrLikes = numberLikes != 1 ? "likes" : "like"
        
        numberLikesLabel.text = "\(numberLikes) \(likeOrLikes)"
        likesContainer.hidden = false
    }
    
    func getColoredText(word: String, description: String?, color:UIColor) -> NSMutableAttributedString {
        let string:NSMutableAttributedString = NSMutableAttributedString(string: word)
        
        let range:NSRange = (string.string as NSString).rangeOfString(word)
        string.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        
        if(description != nil){
            string.appendAttributedString(NSAttributedString(string: " " + description!))
        }
        
        return string
    }
    
    func locationTapped(){
        performSegueWithIdentifier("remnantLocationSegue", sender: self)
    }
    
    func leftButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func rightButtonTapped() {
        
    }
    
    func likeTapped(){
        if(likeButton.titleLabel!.text == "like"){
            likeRemnant()
        }
        else if(likeButton.titleLabel!.text == "liked" && likeActivity != nil){
            unlikeRemnant()
        }
        
        refreshLikes()
    }
    
    func likeRemnant(){
        numberLikes++
        self.likeButton.setupFontAwesome("fa-heart", title: "liked", color: UIColor.redColor())
        DataAccessLayer.likeRemnant((selectedRemnant?.objectId)!, toUser: (selectedRemnant!["user"] as! PFUser).objectId!).then({ (likeActivityResult:PFObject?) -> Void in
            self.likeActivity = likeActivityResult
        }).error { (error:ErrorType) -> Void in
            print("There was an error liking the remnant. \(error)")
        }
    }
    
    func unlikeRemnant(){
        numberLikes--
        self.likeButton.setupFontAwesome("fa-heart-o", title: "like", color: UIColor.redColor())
        DataAccessLayer.unlikeRemnant(self.selectedRemnant!.objectId!, likeActivityId: likeActivity!.objectId!).then({ (data:AnyObject?) -> Void in
            self.likeActivity = nil
        }).error { (error:ErrorType) -> Void in
            print("There was an error unliking the remnant. \(error)")
        }
    }
    
    func addToTapped(){
        print("add-to tapped")
    }
    
    func saveTapped(){
        print("save tapped")
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "backToStartup"){
            let startupViewController = segue.destinationViewController as! StartupViewController
            startupViewController.isInitialLoad = true
        }
        else if(segue.identifier == "remnantLocationSegue"){
            let remnantLocationViewController = segue.destinationViewController as! RemnantLocationController
            remnantLocationViewController.selectedRemnant = Remnant.parsePFObject(selectedRemnant!)
        }
    }

}
