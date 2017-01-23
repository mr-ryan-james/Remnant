//
//  FiltersViewController.swift
//  ios
//
//  Created by System Administrator on 10/27/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, PhotoContainerChildViewController {
    typealias ParentContainerType = EditImageViewController
    
    var container:ParentContainerType? = nil
    @IBOutlet weak var filtersScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFiltersTool()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupFiltersTool() {
        // Variables for setting the Buttons
        var xCoord: CGFloat = 10
        let yCoord: CGFloat = 10
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 10
        
        // Counter for Filters
        var itemCount = 0
        
        // Loop for creating buttons =========================
        for itemCount = 0; itemCount < filters.filtersList.count; ++itemCount {
            let filterTAG = itemCount
            
            // Create a Button for each Texture ==========
            let filterButton = UIButton(type: UIButtonType.Custom)
            filterButton.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
            filterButton.tag = filterTAG
            filterButton.showsTouchWhenHighlighted = true
            filterButton.setImage(UIImage(named: "f\(filterTAG)"), forState: UIControlState.Normal)
            filterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            filterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            filterButton.layer.borderWidth = 1
            filterButton.layer.borderColor = UIColor.darkGrayColor().CGColor
            // filterButt?.layer.cornerRadius = 8
            filterButton.clipsToBounds = true
            
            // Add a Label that shows Filter Name =========
            let filterLabel: UILabel = UILabel()
            filterLabel.frame = CGRectMake(0, filterButton.frame.size.height-15, buttonWidth, 15)
            filterLabel.backgroundColor = UIColor.blackColor()
            filterLabel.alpha = 0.8
            filterLabel.textColor = UIColor.whiteColor()
            filterLabel.textAlignment = NSTextAlignment.Center
            filterLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 10)
            filterLabel.text = "\(filters.filterNamesList[itemCount])"
            filterButton.addSubview(filterLabel)
            
            
            // Add Buttons & Labels based on xCood
            xCoord +=  buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButton)
        } // END LOOP =========================================
        
        
        // Place Buttons into the ScrollView =====
        let itemCountFloat = CGFloat(Int(itemCount))
        filtersScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(itemCountFloat+4), yCoord)
    }
    
    func filterButtonTapped(button: UIButton){
        let tag = button.tag
        
        if(tag == 0){
            container!.originalImageView.image = container!.imageFromCamera!
        }
        else{
            container!.originalImageView.image = filters.processFilter(tag, image: container!.imageFromCamera!)
        }
    }
}
