//
//  TouchesDelegate.swift
//  ios
//
//  Created by System Administrator on 10/27/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation


protocol TouchesFromOtherControllerDelegate {
    func touchesBeganInOtherController(touches: Set<UITouch>, withEvent event: UIEvent?) -> Void
    func touchesMovedInOtherController(touches: Set<UITouch>, withEvent event: UIEvent?) -> Void
    func touchesEndedInOtherController(touches: Set<UITouch>, withEvent event: UIEvent?) -> Void
}