//
//  PlayViewController.swift
//  UniversalPlayer
//
//  Created by Michael Kuehl on 12.02.15.
//  Copyright (c) 2015 ratchet.cc. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController, AVAudioPlayerDelegate {

    // title
    @IBOutlet weak var episodeTitle: UILabel!
    
    // episode button
    @IBOutlet weak var episodeImage: UIButton!
    
    // volume sliders
    @IBOutlet weak var vocalsSlider: UISlider!
    @IBOutlet weak var musicSlider: UISlider!
    
    // start, pause & stop buttons
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    private var catalog: AssetCatalog!
    private var bundle: AssetBundle!
    
    private var vocalPlayer: AVAudioPlayer!
    private var musicPlayer: AVAudioPlayer!
    
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // UI SETUP
        //
        startButton.hidden = false
        stopButton.hidden = true
        pauseButton.hidden = true
        
        // init the catalog
        catalog = AssetCatalog.sharedInstance
        
        // the currently selected bundle
        reset()
        
        // init the players
        musicPlayer = bundle.background() // by convention, this is the background loop
        musicPlayer.numberOfLoops = -1
        musicPlayer.currentTime = 0
        
        vocalPlayer = bundle.next()
        vocalPlayer.delegate = self
        vocalPlayer.currentTime = 0
        
        // set the title
        episodeTitle.text = bundle.title
    }

    private func reset() {
        bundle = catalog.currentBundle()
        bundle.reset()
        bundle.skipIntro( defaults.boolForKey("state_intro"))
        bundle.skipWakeup( defaults.boolForKey("state_wakeup"))
    }
    
    // audio player callbacks
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        
        var next = bundle.next()
        
        if next == nil {
            // last vocal track ended, reset now ...
            startButton.hidden = false
            stopButton.hidden = true
            pauseButton.hidden = true
            
            musicPlayer.stop()
            vocalPlayer.stop()
            
            reset()
            vocalPlayer = bundle.next()
            vocalPlayer.delegate = self
            
        } else {
            // switch to the next vocal track
            vocalPlayer = next
            vocalPlayer.delegate = self
            vocalPlayer.play()
        }
    }
    
    //
    // start, pause & stop buttons
    //
    @IBAction func startButtonPressed(sender: AnyObject) {
        // set the button state
        startButton.hidden = true
        stopButton.hidden = false
        pauseButton.hidden = false
        
        musicPlayer.play()
        vocalPlayer.play()
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        // set the button state
        stopButton.hidden = true
        pauseButton.hidden = true
        startButton.hidden = false
        
        musicPlayer.stop()
        vocalPlayer.stop()
        
        // reset the vocal track
        reset()
        vocalPlayer = bundle.next()
        vocalPlayer.delegate = self
    }
    
    @IBAction func pauseButtonPressed(sender: AnyObject) {
        // set the button state
        stopButton.hidden = true
        pauseButton.hidden = true
        startButton.hidden = false
        
        musicPlayer.stop()
        vocalPlayer.stop()
    }
    
    //
    // volume sliders
    //
    @IBAction func vocalsSliderChanged(sender: UISlider) {
        vocalPlayer.volume = sender.value
    }
    
    @IBAction func musicSliderChanged(sender: UISlider) {
        musicPlayer.volume = sender.value
    }
    
    //
    // navigate to the details page, even if not used at the moment
    //
    @IBAction func toDetailsView(sender: UIButton) {
        let detailsView = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsView") as DetailsViewController
        self.presentViewController(detailsView, animated: true, completion: nil)
    }
    
    // system callbacks
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

