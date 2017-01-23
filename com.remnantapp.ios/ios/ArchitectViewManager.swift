//
//  ArchitectViewManager.swift
//  ios
//
//  Created by System Administrator on 9/28/15.
//  Copyright © 2015 puhfista. All rights reserved.
//

import Foundation

@objc class ArchitectViewManager : NSObject{

    static var _av:WTArchitectView? = nil
    
    static let licenseKey = "PMtN1CN03BqX8AbRaLL7iFtJn60u0hzRuKnNQBL6IOXHwDL5ivOOZdxHVtrSetxRukZ8sF+SiNT0q5rQewQbH/OLkmSC4TQ93quzZQiZkKGCVGooJ4gJmduJKvn2CvsXI3AZGl3eANgDZpFJa5bJzqVGEoSfVOlAMf0CBN4uK1FTYWx0ZWRfX/b2wxlc8TbVeyHp9YUj97tkm2N4zBZkS03YZrWUZoMrbzc44ic5KZ0P1hLAyA9ZFtEJ94CfdVmRgQjpE1uJJ7vESTmMA/gj/4BQqp7NVdIv9i3esE+Q9lp8ETxlIvwvEONvFA+aXlIP6lH3BHP1F2YfbXQ0CdLU/Gp7/ekUqqf0cSoielSmlaopIxfgeq7MJkLBbcmHgHSNvy90d7PiU3y3jmeP4jtvZ+zCwYVEVdrzcR7ImdQMWfpi60wD+awp4yhpd5z6xMcsnYMdLZVnbP2bDGDhFzX40Colc//8EzuJNKWRPavNf+YEUwF/QAmpM4U9jxVJq+5Oe5fveMXgRwgWkj5br57ax8qlfW1pX6WouQdA5syifgCWmjQIuClA8utp60KYcELmt5zKd/CgPgw6gzPHs8i2P060E8lxCOuIm1YuE9KHyiddvb/FeRiBkFiP7iyMXE8LcF8IpWaavzWWdMATMfmchtTbMSHmlVuXj2hgJJJrQKU="
    
    class func getArchitectView(normalDelegate:WTArchitectViewDelegate, debugDelegate: WTArchitectViewDebugDelegate) -> WTArchitectView{
        
        print("getArchitectView")
        
        if(_av != nil){
            print("av is not nil")
            return _av!
        }
        
        print("av is nil")
        
        //_av = [[WTArchitectView alloc] initWithFrame:CGRectZero motionManager:nil];
        _av =  WTArchitectView(frame: CGRectZero)
        _av!.delegate = normalDelegate
        _av!.debugDelegate = debugDelegate
        
        _av?.setLicenseKey(licenseKey)
        
        _av!.translatesAutoresizingMaskIntoConstraints = false
        
        return _av!
    }
    
    class func setToNil(){
        _av = nil
    }
    
    
    
    
    
    
}