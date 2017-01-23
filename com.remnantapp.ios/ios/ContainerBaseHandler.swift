//
//  ContainerBaseViewController.swift
//  ios
//
//  Created by System Administrator on 11/2/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit

class ContainerBaseHandler<ParentTypeViewController:UIViewController> {

    
    var currentSegue:String? = nil
    var transitionInProgress = false
    var container:ParentTypeViewController? = nil
    
    var currentController:UIViewController?
    
    init(thisController:UIViewController, containerController: ParentTypeViewController) {
        currentController = thisController
        
    }
    
    func setTransitionInProgress(){
        transitionInProgress = true
    }
    
    func handleSegue(segue: UIStoryboardSegue){
        if(currentController!.childViewControllers.count == 0){
            loadInitialViewController(segue)
        }
        else if(transitionInProgress == false && currentSegue != segue.identifier){
            transitionInProgress = true
            currentSegue = segue.identifier
            swapFromViewController(currentController!.childViewControllers[0], toViewController: segue.destinationViewController)
        }
    }
    

    func loadInitialViewController(segue: UIStoryboardSegue){
        currentController!.addChildViewController(segue.destinationViewController)
        let destView = segue.destinationViewController.view
        destView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        destView.frame = CGRect(x: 0, y: 0, width: currentController!.view.frame.size.width, height: currentController!.view.frame.size.height)
        currentController!.view.addSubview(destView)
        segue.destinationViewController.didMoveToParentViewController(currentController)
    }
    
    func swapFromViewController(fromViewController:UIViewController, toViewController:UIViewController){
        toViewController.view.frame = CGRectMake(0, 0, currentController!.view.frame.size.width, currentController!.view.frame.size.height)
        fromViewController.willMoveToParentViewController(nil)
        
        currentController!.addChildViewController(toViewController)
        
        currentController!.transitionFromViewController(fromViewController, toViewController: toViewController, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: { () -> Void in
            //what should I put in here?
            }) { (finished:Bool) -> Void in
                fromViewController.removeFromParentViewController()
                toViewController.didMoveToParentViewController(self.currentController)
                self.transitionInProgress = false
        }
    }
}