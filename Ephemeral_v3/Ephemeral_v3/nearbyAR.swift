//
//  nearbyAR.swift
//  Ephemeral_v3
//
//  Created by Chang Gao on 4/29/18.
//  Copyright © 2018 Ephemeral. All rights reserved.
//

import UIKit
import AVFoundation

class nearbyAR: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var playerView: PlayerView!
    
    let player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoPlayer()
        
    }
    
    func setupVideoPlayer() {
        
        // Guard allows us to make sure we have a valid video resource before we go any further
        guard let videoUrl = Bundle.main.url(forResource: "2", withExtension: "mp4") else {
            print("Error: Could not find video!")
            return // If we can't find the video, we do nothing
        }
        
        // Create a video item from our resource
        // https://developer.apple.com/documentation/avfoundation/avplayeritem
        let videoItem = AVPlayerItem(url: videoUrl)
        self.player.replaceCurrentItem(with: videoItem)
        
        // Quick and easy way to mask
        self.playerView.layer.cornerRadius = self.playerView.frame.width / 2.0
        self.playerView.layer.masksToBounds = true
        
        // Fill the whole box
        self.playerView.playerLayer.videoGravity = .resizeAspectFill
        
        // Assign our player to our custom playerView
        self.playerView.player = self.player
        
        // Some logic for looping
        self.loopPlayer()
        
        // Start playing
        self.player.play()
    }
    func loopPlayer() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { _ in
            self.player.seek(to: kCMTimeZero)
            self.player.play()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePop(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
