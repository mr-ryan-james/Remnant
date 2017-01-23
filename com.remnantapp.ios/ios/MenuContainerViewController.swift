//
//  ContainerViewController.swift
//  Taasky
//
//  Created by System Administrator on 10/16/15.
//  Copyright © 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class MenuContainerViewController: UIViewController, UIScrollViewDelegate {

    private var startupViewController: StartupViewController?
    private var menuViewController: MenuViewController?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var contentContainerView: UIView!
    
    var showingMenu = false
    
    var menuItem: NSDictionary? {
        didSet {
            hideOrShowMenu(false, animated: true)
            if let startupViewController = startupViewController{
                startupViewController.menuItem = menuItem
            }
        }
    }
    
    func transformForFraction(fraction:CGFloat) -> CATransform3D {
        var identity = CATransform3DIdentity
        identity.m34 = -1.0 / 1000.0;
        let angle = Double(1.0 - fraction) * -M_PI_2
        let xOffset = CGRectGetWidth(menuContainerView.bounds) * 0.5
        let rotateTransform = CATransform3DRotate(identity, CGFloat(angle), 0.0, 1.0, 0.0)
        let translateTransform = CATransform3DMakeTranslation(xOffset, 0.0, 0.0)
        return CATransform3DConcat(rotateTransform, translateTransform)
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("contianer view controller view did load")
        
        scrollView.delegate = self
        scrollView.setContentOffset(CGPointZero, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        menuContainerView.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        hideOrShowMenu(showingMenu, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("contianer view controller --> prepareForSegue:\(segue.destinationViewController) - \(segue.identifier)")
        
        if(segue.identifier == "contentViewSegue"){
            startupViewController = segue.destinationViewController as? StartupViewController
            startupViewController!.container = self
            
            if(menuViewController != nil){
                menuViewController?.startupViewController = startupViewController
            }
        }
        else if(segue.identifier == "menuContainerSegue"){
            menuViewController = segue.destinationViewController as? MenuViewController
            menuViewController!.container = self
            
            if(startupViewController != nil){
                menuViewController?.startupViewController = startupViewController
            }
        }
    }
    
    func hideOrShowMenu(show: Bool, animated: Bool) {
        showingMenu = show
        let menuOffset = CGRectGetWidth(menuContainerView.bounds)
        scrollView.setContentOffset(show ? CGPointZero : CGPoint(x: menuOffset, y: 0), animated: animated)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let multiplier = 1.0 / CGRectGetWidth(menuContainerView.bounds)
        let offset = scrollView.contentOffset.x * multiplier
        let fraction = 1.0 - offset
        menuContainerView.layer.transform = transformForFraction(fraction)
        menuContainerView.alpha = fraction
        
        hamburgerRotation(fraction)

        
        //keep the menu from popping out when its not supposed to
        scrollView.pagingEnabled = scrollView.contentOffset.x < (scrollView.contentSize.width - CGRectGetWidth(scrollView.frame))
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let menuOffset = CGRectGetWidth(menuContainerView.bounds)
        showingMenu = !CGPointEqualToPoint(CGPoint(x: menuOffset, y: 0), scrollView.contentOffset)
        print("didEndDecelerating showingMenu \(showingMenu)")
    }
    
    func hamburgerRotation(fraction: CGFloat){
        if let startupViewController = startupViewController {
            if let rotatingView = startupViewController.hamburgerView {
                rotatingView.rotate(fraction)
            }
        }
    }

}