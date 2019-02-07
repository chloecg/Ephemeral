//
//  PlayerView.swift
//  Ephemeral_v3
//
//  Created by Chloe Gao on 4/29/18.
//  Copyright © 2018 Ephemeral. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

// Reference:
// https://developer.apple.com/documentation/avfoundation/avplayerlayer

class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

