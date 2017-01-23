//
//  RemnantWorldHelpers.swift
//  ios
//
//  Created by System Administrator on 11/11/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation

@objc class RemnantWorldHelper : NSObject{
    func HandleCommandFromWorld(remnantWorldViewController:UIViewController, command:NSURL?){
        
        remnantWorldViewController.performSegueWithIdentifier("remnantSegue", sender: self)
    }
    
    func HandleSegue(remnantWorldViewController:UIViewController, segue:UIStoryboardSegue, command:NSURL?){
        if(segue.identifier == "remnantSegue"){
            let remnantViewController = segue.destinationViewController as? RemnantViewController
            let commandArry = command?.absoluteString.characters.split { $0 == "=" }.map(String.init)
            remnantViewController?.remnantId = commandArry![1]
        }
    }
}