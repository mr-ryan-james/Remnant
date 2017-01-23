//
//  CircleView.swift
//  ios
//
//  Created by System Administrator on 10/17/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation

class CircleView : UIView{
    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect)
        UIColor.redColor().setFill()
        path.fill()
    }
}