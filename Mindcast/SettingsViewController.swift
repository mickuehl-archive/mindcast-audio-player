//
//  SettingsViewController.swift
//  UniversalPlayer
//
//  Created by Michael Kuehl on 12.02.15.
//  Copyright (c) 2015 ratchet.cc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var introSwitch: UISwitch!
    @IBOutlet weak var wakeUpSwitch: UISwitch!
    
    private var defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the switches
        if (defaults.objectForKey("state_intro") != nil) {
            introSwitch.on = defaults.boolForKey("state_intro")
        }
        
        if (defaults.objectForKey("state_wakeup") != nil) {
            wakeUpSwitch.on = defaults.boolForKey("state_wakeup")
        }
        
        // setup the callbacks
        introSwitch.addTarget(self, action: Selector("stateChangedIntro:"), forControlEvents: UIControlEvents.ValueChanged)
        wakeUpSwitch.addTarget(self, action: Selector("stateChangedWakeUp:"), forControlEvents: UIControlEvents.ValueChanged)
    }

    func stateChangedIntro(switchState: UISwitch) {
        if introSwitch.on {
            defaults.setBool(true, forKey: "state_intro")
        } else {
            defaults.setBool(false, forKey: "state_intro")
        }
        AssetCatalog.sharedInstance.currentBundle().skipIntro( defaults.boolForKey("state_intro"))
    }
    
    func stateChangedWakeUp(switchState: UISwitch) {
        if wakeUpSwitch.on {
            defaults.setBool(true, forKey: "state_wakeup")
        } else {
            defaults.setBool(false, forKey: "state_wakeup")
        }
        AssetCatalog.sharedInstance.currentBundle().skipWakeup( defaults.boolForKey("state_wakeup"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
