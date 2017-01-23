//
//  DrawingViewController.swift
//  ios
//
//  Created by System Administrator on 10/27/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, TouchesFromOtherControllerDelegate, PhotoContainerChildViewController {
    typealias ParentContainerType = EditImageViewController
    
    var container:ParentContainerType? = nil
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    var reuseIdentifier = "abcxyz"
    
    var colorsArray:NSMutableArray = []
    var emptyCanvas:UIImageView? = nil
    var tempEmptyCanvas:UIImageView? = nil
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view..
        
        colorsArray.addObject(UIColor.blackColor())
        colorsArray.addObject(UIColor.whiteColor())
        
        let increment = 0.05;
        for (var hue = 0.0; hue < 1.0; hue += increment) {
            let color = UIColor(hue: CGFloat(hue), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            colorsArray.addObject(color)
        }
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        container!.touchesFromOtherControllerDelegate = self
        
        //addEmptyCanvasToContainer()
    }

    
    override func viewDidLayoutSubviews() {
        addEmptyCanvasToContainer()
    }
    
    func addEmptyCanvasToContainer(){
        emptyCanvas = UIImageView()
        emptyCanvas!.frame = container!.originalImageView.frame
        emptyCanvas!.backgroundColor = UIColor.clearColor()
        
        tempEmptyCanvas = UIImageView()
        tempEmptyCanvas!.frame = container!.originalImageView.frame
        tempEmptyCanvas!.backgroundColor = UIColor.clearColor()
        
        container!.originalImageView.addSubview(tempEmptyCanvas!)
        container!.originalImageView.addSubview(emptyCanvas!)
    }
    
    func touchesBeganInOtherController(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesBeganInOtherController")
        
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(container!.originalImageView)
        }
    }
    
    func touchesMovedInOtherController(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesMovedInOtherController")
        
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(container!.originalImageView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    func touchesEndedInOtherController(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesEndedInOtherController")
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(container!.originalImageView.frame.size)
        emptyCanvas!.image?.drawInRect(CGRect(x: 0, y: 0, width: container!.originalImageView.frame.size.width, height: container!.originalImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempEmptyCanvas!.image?.drawInRect(CGRect(x: 0, y: 0, width: container!.originalImageView.frame.size.width, height: container!.originalImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        emptyCanvas!.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempEmptyCanvas!.image = nil
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        let myCIColor = CIColor(color: (colorsArray[selectedIndex] as! UIColor))
        let selectedColor = CGColorGetComponents((colorsArray[selectedIndex] as! UIColor).CGColor)
        red = myCIColor.red
        green = myCIColor.green
        blue = myCIColor.blue
        //alpha = selectedColor[3]
        
        // 1
        UIGraphicsBeginImageContext(container!.originalImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempEmptyCanvas!.image?.drawInRect(CGRect(x: 0, y: 0, width: container!.originalImageView.frame.size.width, height: container!.originalImageView.frame.size.height))
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        tempEmptyCanvas!.image = UIGraphicsGetImageFromCurrentImageContext()
        tempEmptyCanvas!.alpha = opacity
        UIGraphicsEndImageContext()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ryansCell", forIndexPath: indexPath)
        cell.backgroundColor = colorsArray[indexPath.row] as? UIColor
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        colorCollectionView.backgroundColor = colorsArray[selectedIndex] as? UIColor
        
    }
    
}
