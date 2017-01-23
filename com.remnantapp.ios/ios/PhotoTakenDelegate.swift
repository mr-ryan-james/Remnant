//
//  PhotoTaken.swift
//  ios
//
//  Created by System Administrator on 9/29/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation

protocol PhotoTakenDelegate {
    func photoTaken(image: UIImage) -> Void
}