//
//  HamburgerView.swift
//  Taasky
//
//  Created by System Administrator on 10/16/15.
//  Copyright © 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class HamburgerView: UIView {
    
    let imageView: UIImageView! = UIImageView(image: UIImage.fontAwesomeIconWithName(FontAwesome.Bars, textColor: UIColor.whiteColor(), size: CGSizeMake(40, 40)))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    // MARK: Private
    
    private func configure() {
        imageView.contentMode = UIViewContentMode.Center
        addSubview(imageView)
    }
    
    func rotate(fraction: CGFloat) {
        let angle = Double(fraction) * M_PI_2
        imageView.transform = CGAffineTransformMakeRotation(CGFloat(angle))
    }
}
 