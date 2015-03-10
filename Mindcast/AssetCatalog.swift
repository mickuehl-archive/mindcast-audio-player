//
//  AssetCatalog.swift
//  UniversalPlayer
//
//  Created by Michael Kuehl on 15.02.15.
//  Copyright (c) 2015 ratchet.cc. All rights reserved.
//

import UIKit

class AssetCatalog: NSObject, NSURLSessionDelegate {
   
    class var sharedInstance: AssetCatalog {
        struct Singleton {
            static let instance = AssetCatalog()
        }
        return Singleton.instance
    }
    
    private var documentsUrl: String!
    
    // internal data
    private var bundles = [AssetBundle]()
    private var bundleIdx = 0 as Int
    
    override init() {
        super.init()
        
        // find the documents folder URL
        let fileManager = NSFileManager()
        let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentationDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as [NSURL]
        // just assume success, why not?
        documentsUrl = "\(urls[0])"
        
        // add the default asset
        var asset = AssetBundle(uid: "E000", title: "The default Episode", subtitle: "Something awesome")
        self.append( asset)
    }
    
    func refresh() {
        
        // retrieve the episode index from the backend and update the local data
        
        var session: NSURLSession!
        
        // init the URL session we use to access the backend
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 20.0
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let url = NSURL(string: "http://www.ratchet.cc/assets/blog/2015/index.json")
        
        let task = session.dataTaskWithURL(url!, completionHandler: {
            [weak self] (data: NSData!, response: NSURLResponse!, error: NSError!) in
            
            if data == nil {
                // could not get data from backend, no internet?
                println("NO DATA")
            } else {
                // update the index
                /*
                let assets = JSON(data: data)
                
                for var i = 0; i < assets.count; i++ {
                    // just a primitive implementation for now ...
                    let uid = assets[i]["uid"]
                    let title = assets[i]["title"]
                    let subtitle = assets[i]["subtitle"]
                    
                    var asset = AssetBundle(uid: "\(uid)", title: "\(title)", subtitle: "\(subtitle)")
                    self?.append( asset)
                }
                */
            }
            
            // done, invalidate the session
            session.finishTasksAndInvalidate()
        })
        
        task.resume()
    }
    
    func currentBundle() -> AssetBundle {
        return bundles[bundleIdx]
    }
    
    func append(bundle: AssetBundle) -> Bool {
        bundles.append(bundle)
        return true
    }
}

