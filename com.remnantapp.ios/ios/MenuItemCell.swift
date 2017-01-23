//
//  MenuItemCell.swift
//  Taasky
//
//  Created by Audrey M Tam on 18/03/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var alertsCircleView: CircleView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuItemImageView: UIImageView!
    let newLine = "\n";
    
    func configureForMenuItem(menuItem: NSDictionary) {
        let faName = menuItem["image"] as! String
        print(faName)
        let fontAwesome = FontAwesome(rawValue: FontAwesomeIcons[faName]!)!
        menuItemImageView.image = UIImage.fontAwesomeIconWithName(fontAwesome, textColor: UIColor(colorArray: menuItem["faColor"] as! NSArray), size: CGSizeMake(30, 30))
        
        backgroundColor = UIColor(colorArray: menuItem["colors"] as! NSArray)
        
        menuItemImageView.layer.borderColor = UIColor(colorArray: [200,200,200]).CGColor
        menuItemImageView.layer.borderWidth = 1
        
        let labelText = menuItem["label"] as! String
        menuLabel.text = labelText.stringByReplacingOccurrencesOfString("\\n", withString: newLine)
        menuLabel.textColor = UIColor(colorArray: menuItem["textColor"] as! NSArray)
        
        if(faName == "fa-bell"){
            let badgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber
            
            if(badgeNumber == 0){
                return
            }
            
            alertsCircleView.hidden = false
            alertsCircleView.addSubview(addAlertLabel(badgeNumber))
        }
        
    }
    
    func addAlertLabel(badgeNumber:Int) -> UILabel{
        let label = UILabel()
        label.frame = CGRect(x:0, y:0, width: 25, height: 25)
        let labelPoint = UIUtility.GetCenterOfView(alertsCircleView)
        label.center = labelPoint
        label.text = "\(badgeNumber)"
        label.font = UIFont.boldSystemFontOfSize(CGFloat(15))
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        return label
    }
}