//
//  RemnanFontAwesome.swift
//  ios
//
//  Created by System Administrator on 11/2/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation


extension UITabBarItem{
    func setupFontAwesome(fontAwesomeName: String){
        self.image = UIImage.fontAwesomeIconWithName(FontAwesome(rawValue: FontAwesomeIcons[fontAwesomeName]!)!, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
    }
}

extension UIBarButtonItem{
    func setupFontAwesome(fontAwesomeName: String){
        self.image = UIImage.fontAwesomeIconWithName(FontAwesome(rawValue: FontAwesomeIcons[fontAwesomeName]!)!, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
    }
}

extension UIButton{
    func setupFontAwesome(fontAwesomeName: String, color:UIColor = UIColor.grayColor(), title:String? = nil, actionTarget:AnyObject? = nil, action:String? = nil, height:Int = 30, width:Int = 30){
        let fontAwesomeImage = UIImage.fontAwesomeIconWithName(FontAwesome(rawValue: FontAwesomeIcons[fontAwesomeName]!)!, textColor: color, size: CGSizeMake(CGFloat(width), CGFloat(height)))
        
        self.setBackgroundImage(fontAwesomeImage, forState: UIControlState.Normal)
        
        self.setTitle(title, forState: UIControlState.Normal)

        if(title != nil){
            self.centerLabelVerticallyWithPadding(CGFloat(height))
            self.titleLabel!.font = UIFont.systemFontOfSize(10)
            self.titleLabel?.sizeToFit()
        }
        
        if(actionTarget != nil && action != nil){
            self.addGestureRecognizer(UITapGestureRecognizer(target: actionTarget, action: Selector(action!)))
        }
    }
    
    func centerLabelVerticallyWithPadding(spacing:CGFloat) {
        // update positioning of image and title
        let imageSize = self.imageView!.frame.size
        self.titleEdgeInsets = UIEdgeInsets(top:0,
            left:-imageSize.width,
            bottom:-(imageSize.height + spacing),
            right:0)
        let titleSize = self.titleLabel!.frame.size
        self.imageEdgeInsets = UIEdgeInsets(top:-(titleSize.height + spacing),
            left:0,
            bottom: 0,
            right:-titleSize.width)
        
        // reset contentInset, so intrinsicContentSize() is still accurate
        let trueContentSize = CGRectUnion(self.titleLabel!.frame, self.imageView!.frame).size
        let oldContentSize = self.intrinsicContentSize()
        let heightDelta = trueContentSize.height - oldContentSize.height
        let widthDelta = trueContentSize.width - oldContentSize.width
        self.contentEdgeInsets = UIEdgeInsets(top:heightDelta/2.0,
            left:widthDelta/2.0,
            bottom:heightDelta/2.0,
            right:widthDelta/2.0)
    }
}

extension UIImageView{
    func setupFontAwesome(fontAwesomeName: String, tapAction: UITapGestureRecognizer?, textColor:UIColor = UIColor.blackColor(), height:Int = 30, width:Int = 30){
        self.image = UIImage.fontAwesomeIconWithName(FontAwesome(rawValue: FontAwesomeIcons[fontAwesomeName]!)!, textColor: textColor, size: CGSizeMake(CGFloat(width), CGFloat(height)))
        
        if(tapAction != nil){
            self.addGestureRecognizer(tapAction!)
            self.userInteractionEnabled = true
        }
    }
}