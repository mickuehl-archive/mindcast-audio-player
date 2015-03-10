//
//  AssetBundle.swift
//  UniversalPlayer
//
//  Created by Michael Kuehl on 15.02.15.
//  Copyright (c) 2015 ratchet.cc. All rights reserved.
//

import UIKit
import AVFoundation

class AssetBundle: NSObject {
   
    // public metadata
    var uid: String!        // uid of the bundle
    
    var title: String!      // the title of the bundle
    var subtitle: String!   // subtitle of the bundle
    var summary: String!    // a detailed description of the bundle
    
    // array of asset URLs
    private var assets = [NSURL]()
    private var assetIdx = 0 as Int
    private var skipIntro = false as Bool
    private var skipWakeup = false as Bool
    
    init(uid: String) {
        super.init()
        
        self.uid = uid
        
        // download metadata
    }
    
    init(uid: String, title: String, subtitle: String) {
        super.init()
        
        self.uid = uid
        
        self.title = title
        self.subtitle = subtitle
        self.summary = "\(title) - \(subtitle)"
        
        // download additional metadata
        
        // check if stuff is already local
        locateLocalAsset(uid + "_background", ext: "mp3")
        locateLocalAsset(uid + "_intro", ext: "mp3")
        locateLocalAsset(uid + "_main", ext: "mp3")
        locateLocalAsset(uid + "_wakeup", ext: "mp3")
    }
    
    init(uid: String, title: String, subtitle: String, summary: String) {
        super.init()
        
        self.uid = uid
        
        self.title = title
        self.subtitle = subtitle
        self.summary = summary
        
        // download additional metadata
        
        // check if stuff is already local
        locateLocalAsset(uid + "_background", ext: "mp3")
        locateLocalAsset(uid + "_intro", ext: "mp3")
        locateLocalAsset(uid + "_main", ext: "mp3")
        locateLocalAsset(uid + "_wakeup", ext: "mp3")
    }
    
    func next() -> AVAudioPlayer? {
        if assetIdx == 4 {
            return nil
        }
        
        // skip Intro?
        if assetIdx == 1 && skipIntro {
            assetIdx++
        }
        
        // skip Wake-up?
        if assetIdx == 3 && skipWakeup {
            return nil
        }
        
        assetIdx++
        return assetAtIndex(assetIdx - 1)    }
    
    func reset() {
        self.assetIdx = 1
    }
    
    func background() -> AVAudioPlayer {
        return assetAtIndex(0)!
    }
    
    func skipIntro(flag: Bool) {
        self.skipIntro = flag
    }
    
    func skipWakeup(flag: Bool) {
        self.skipWakeup = flag
    }
    
    private func locateLocalAsset(asset: String, ext: String) -> Bool {
        var error: NSError?
        
        let urlForAsset = NSBundle.mainBundle().URLForResource(asset, withExtension: ext)
        if urlForAsset != nil {
            assets.append(urlForAsset!)
            return true
        } else {
            return false
        }
    }
    
    private func assetAtIndex(idx: Int) -> AVAudioPlayer? {
        if idx >= assets.count {
            return nil
        }
        
        var error: NSError?
        
        // just assume AVAudioPlayer for now
        return AVAudioPlayer( contentsOfURL: assets[idx], error: &error)
    }
    
}
