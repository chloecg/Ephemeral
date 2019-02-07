//
//  nearbyAR.swift
//  Ephemeral_v3
//
//  Created by Chloe Gao on 4/29/18.
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
        
        // Guard makes sure video is valid
        guard let videoUrl = Bundle.main.url(forResource: "nearbyAR", withExtension: "mp4") else {
            print("Error: Could not find video!")
            return
        }
        
        // Create a video item from resource
        // https://developer.apple.com/documentation/avfoundation/avplayeritem
        let videoItem = AVPlayerItem(url: videoUrl)
        self.player.replaceCurrentItem(with: videoItem)
        
        self.playerView.layer.cornerRadius = self.playerView.frame.width / 2.0
        self.playerView.layer.masksToBounds = true
        
    
        self.playerView.playerLayer.videoGravity = .resizeAspectFill
        
        self.playerView.player = self.player
        
        self.loopPlayer()
        
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
