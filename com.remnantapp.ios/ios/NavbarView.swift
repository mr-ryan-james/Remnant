//
//  NavbarView.swift
//  ios
//
//  Created by System Administrator on 10/20/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit

@IBDesignable class NavbarView: UIView {
    
    var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftSideContainer: UIView!
    @IBOutlet weak var rightSideContainer: UIView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    var customNavbarDelegate:CustomNavbarDelegate?
    
    @IBAction func leftButtonTapped(sender: AnyObject) {
        customNavbarDelegate?.leftButtonTapped()
    }
    
    @IBAction func rightButtonTapped(sender: AnyObject) {
        customNavbarDelegate?.rightButtonTapped()
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    func setup() {
        customNavbarDelegate = CustomNavbarDelegate?()
        view = loadViewFromNib()
        
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth]
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NavbarView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
}
