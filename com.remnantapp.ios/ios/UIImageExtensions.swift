//
//  UIImageExtensions.swift
//  ios
//
//  Created by System Administrator on 10/19/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation


extension UIImage{
    class func imageWithColor(color: UIColor) -> UIImage{
        
        let rect = CGRectMake(0, 0, 1, 1)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
    }
}