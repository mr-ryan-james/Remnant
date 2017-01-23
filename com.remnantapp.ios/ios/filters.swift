//
//  filters.swift
//  ios
//
//  Created by System Administrator on 10/26/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation

class filters {
    
    class func processFilter(tag:Int, image:UIImage) -> UIImage{
        
        // MARK: - FILTER SETTINGS ------------------------------------
        
        let CIfilterName = "\(filters.filtersList[tag])"
        print("\(CIfilterName)")
        
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        let filter = CIFilter(name: CIfilterName)
        filter!.setDefaults()
        
        
        switch tag {
            
        case 1: // Vignette
            filter!.setValue(3.0, forKey: kCIInputRadiusKey)
            filter!.setValue(4.0, forKey: kCIInputIntensityKey)
            break
            
        case 13: // Orangy
            let color:UIColor = UIColor(red: 247/255.0, green: 174/255.0, blue: 71/255.0, alpha: 1.0)
            filter!.setValue(CIColor(color: color), forKey: kCIInputColorKey)
            filter!.setValue(0.8, forKey: kCIInputIntensityKey)
            break
            
        case 14: // Red X
            let color:UIColor = UIColor(red: 201/255.0, green: 91/255.0, blue: 96/255.0, alpha: 1.0)
            filter!.setValue(CIColor(color: color), forKey: kCIInputColorKey)
            filter!.setValue(0.8, forKey: kCIInputIntensityKey)
            break
            
        case 15: // Canary
            let color:UIColor = UIColor(red: 241/255.0, green: 247/255.0, blue: 71/255.0, alpha: 1.0)
            filter!.setValue(CIColor(color: color), forKey: kCIInputColorKey)
            filter!.setValue(0.8, forKey: kCIInputIntensityKey)
            break
            
        case 16: //Poster
            filter!.setValue(6.0, forKey: "inputLevels")
            break
            
        case 17: // Sharp
            filter!.setValue(0.9, forKey: kCIInputSharpnessKey)
            break
            
        case 18: //Dark
            filter!.setValue(3, forKey: "inputPower")
            break
            
        case 19: //Tint 1
            filter!.setValue(3.10, forKey: kCIInputAngleKey)
            break
            
        case 20: //Tint 2
            filter!.setValue(2.00, forKey: kCIInputAngleKey)
            break
            
        case 21: //Tint 3
            filter!.setValue(1.00, forKey: kCIInputAngleKey)
            break
            
        case 22: //Vintage
            filter!.setValue(0.5, forKey:"inputIntensity")
            break
            
            
            /* You can add new filters settings here,
            Check Core Image Filter Reference here: https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html
            */
            
            
        default: break }
        
        
        // Log the Filters attributes in the XCode console
        // println("\(filter.attributes())")
        
        // Finalize the filtered image ==========
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.valueForKey(kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
        
        return  UIImage(CGImage: filteredImageRef);
        
    }
    
    
    static let filtersList = [
        "None",                    //0
        "CIVignette",              //1
        "CIPhotoEffectInstant",    //2
        "CIPhotoEffectProcess",    //3
        "CIPhotoEffectTransfer",   //4
        "CISepiaTone",             //5
        "CIPhotoEffectChrome",     //6
        "CIPhotoEffectFade",       //7
        "CIPhotoEffectTonal",      //8
        "CIPhotoEffectNoir",       //9
        "CIMaximumComponent",      //10
        "CIMinimumComponent",      //11
        "CIDotScreen",             //12
        "CIColorMonochrome",       //13
        "CIColorMonochrome",       //14
        "CIColorMonochrome",       //15
        "CIColorPosterize",        //16
        "CISharpenLuminance",      //17
        "CIGammaAdjust",           //18
        "CIHueAdjust",             //19
        "CIHueAdjust",             //20
        "CIHueAdjust",             //21
        "CISepiaTone",             //22
        
        // Add here new CIFilters...
    ]
    
    static let filterNamesList = [
        "None",        //0
        "Vignette",    //1
        "Imagine",     //2
        "Retro",       //3
        "Chic",        //4
        "Sepia",       //5
        "Light",       //6
        "Aqua",        //7
        "Tonal",       //8
        "Noir",        //9
        "Darken",      //10
        "Rude",        //11
        "Dotted",      //12
        "Orange",      //13
        "Reddy",       //14
        "Canary",      //15
        "Poster",      //16
        "Sharp",       //17
        "Boris",       //18
        "Marylin",     //19
        "Fantik",      //20
        "Ipse",        //21
        "Vintiq",      //22
        
        //Set new Filter Names here...
        
    ]
}