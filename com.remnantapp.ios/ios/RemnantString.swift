//
//  RemnantString.swift
//  ios
//
//  Created by System Administrator on 11/17/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation

extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}