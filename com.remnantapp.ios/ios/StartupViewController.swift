//
//  StartupViewController.swift
//  ios
//
//  Created by puhfista on 8/5/15.
//  Copyright (c) 2015 puhfista. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import ParseFacebookUtilsV4

class StartupViewController : UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, SocialSignUpCompleteDelegate, RemnantAddedDelegate {
    
    enum OneShotLocationManagerErrors: Int {
        case AuthorizationDenied
        case AuthorizationNotDetermined
        case InvalidLocation
    }
    
    var initialRemnantsBound = false
    var isInitialLoad = true
    var hamburgerView: HamburgerView?
    var logInViewController: LoginViewController! = LoginViewController()
    var container:MenuContainerViewController?
    var addRemnant:UIImageView? = nil
    
    @IBOutlet weak var customNavigationBar: NavbarView!
    
    
    @IBAction func remantWorldTapped(sender: AnyObject) {
        performSegueWithIdentifier("navigationSegue", sender: self)
    }
    
    @IBAction func addRemnantTapped(sender: AnyObject) {
        performSegueWithIdentifier("addRemnantSegue", sender: self)
    }
    
    @IBAction func backFromOtherController(segue: UIStoryboardSegue) {
        NSLog("I'm back from other controller!")
    }
    
    var menuItem: NSDictionary? {
        didSet {
            if let newMenuItem = menuItem {
                print("hi from startup view controller")
                
                if let segue = newMenuItem["segue"] as! String?{
                    performSegueWithIdentifier( segue, sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        
        
        initHamburger()
    }
    
    func setupCustomNavigationBar(){
        addRemnant = UIImageView(image: UIImage.fontAwesomeIconWithName(FontAwesome.PlusCircle, textColor: UIColor.whiteColor(), size: CGSizeMake(40, 40)))
        addRemnant?.userInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "secondAddRemnantTapped")
        addRemnant!.addGestureRecognizer(tapGestureRecognizer)
        addRemnant!.frame.origin = CGPoint(x: customNavigationBar.rightSideContainer.frame.width - 45, y: 0)
        customNavigationBar.rightSideContainer.addSubview(addRemnant!)
        customNavigationBar.titleLabel.text = "remnant"
    }
    
    func secondAddRemnantTapped(){
        addRemnantTapped(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("startup viewDidAppear")
        
        if(!isInitialLoad){
            return
        }
        
        isInitialLoad = false
        
        
        setupCustomNavigationBar()
        
        
        if(PFUser.currentUser() == nil){
            loadLoginSignupView()
        }
        else{
            loadMainScreen()
        }
    }
    
    func initHamburger(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hamburgerViewTapped")
        hamburgerView = HamburgerView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        hamburgerView!.addGestureRecognizer(tapGestureRecognizer)
        customNavigationBar.leftSideContainer.addSubview(hamburgerView!)
    }
    
    func hamburgerViewTapped() {
        let hideOrShow = !(container!.showingMenu)
        container!.hideOrShowMenu(hideOrShow, animated: true)
    }
    
    func loadLoginSignupView(){
        self.logInViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.Facebook, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten]
        self.logInViewController.delegate = self
        let signUpController = SignUpViewController()
        signUpController.delegate = self
        self.logInViewController.signUpController = signUpController

        
        self.presentViewController(self.logInViewController, animated: true, completion: nil)
    }
    
    func loadMainScreen(){
        print("loading main screen")
        
        
    }
    
    func remnantAdded(remnant: Remnant) -> Void {
        dispatch_async(dispatch_get_main_queue(),{
            
            
        })
    }
    
    func remnantAddedFailedWithError(didFailWithError error: NSError) -> Void {
        print("failed to load remnant")
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Create a new variable to store the instance of PlayerTableViewController
        
        if(segue.identifier == "addRemnantSegue"){
            let newRemnantController = segue.destinationViewController as! NewRemnantController
            newRemnantController.remnantAddedDelegate = self
        }
        else if(segue.identifier == "socialSignUpSegue"){
            let socialSignUpController = segue.destinationViewController as! SocialSignUpViewController
            socialSignUpController.socialSignUpCompleteDelegate = self
        }
        
    }
    
    func socialSignUpComplete(){
        loadMainScreen()
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if(!username.isEmpty || !password.isEmpty){
            return true
        }
        else{
            
            UIUtility.ShowAlert(self.logInViewController, title: "Invalid Login", message: "Double check your login user/pass and try again")
            
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        if(PFFacebookUtils.isLinkedWithUser(user) && (user["signUpComplete"] == nil || user["signUpComplete"] as? Bool == false)){
            performSegueWithIdentifier("socialSignUpSegue", sender: self)
            return
        }
        
        loadMainScreen()
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        UIUtility.ShowAlert(self.logInViewController, title: "Invalid Login", message: "Double check your login user/pass and try again")
    }
    
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        user["signUpComplete"] = true
        user.saveEventually()
        
        self.dismissViewControllerAnimated(true, completion: nil)
        loadMainScreen()
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        UIUtility.ShowAlert(self.logInViewController, title: "Error", message: "\(error)")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        print("user dismissed sign up")
    }
    
}