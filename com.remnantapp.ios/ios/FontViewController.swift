//
//  FontViewController.swift
//  ios
//
//  Created by System Administrator on 10/27/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit

class FontViewController: UIViewController, PhotoContainerChildViewController {
    typealias ParentContainerType = EditImageViewController
    
    var container:ParentContainerType? = nil
    
    var textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("textLabelMove:"))
        panGesture.minimumNumberOfTouches = 1
        
        
        textLabel.userInteractionEnabled = true
        textLabel.frame = CGRect(x:0, y:0, width: 200, height: 100)
        textLabel.center = UIUtility.GetCenterOfView(container!.imageContainerView)
        textLabel.text = "Hello"
        textLabel.font = UIFont.boldSystemFontOfSize(CGFloat(15))
        textLabel.textColor = UIColor.whiteColor()
        textLabel.textAlignment = NSTextAlignment.Center
        
        
        textLabel.addGestureRecognizer(panGesture)
        
        container!.imageContainerView.addSubview(textLabel)
    }

    func textLabelMove(sender: UIPanGestureRecognizer){
        print("trying to move")
        
        let translation: CGPoint =  sender.translationInView(container!.imageContainerView)
        sender.view?.center = CGPointMake(sender.view!.center.x +  translation.x, sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointMake(0, 0), inView: self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
