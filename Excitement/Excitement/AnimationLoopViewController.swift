//
//  AnimationLoopViewController.swift
//  Ephemeral_v3
//
//  Created by Chloe Gao on 4/29/18.
//  Copyright © 2018 Ephemeral. All rights reserved.
//

import UIKit

class AnimationLoopViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // UIView to animate.
    var scaleView: UIView!
    var scaleView2: UIView!
    var scaleView3: UIView!
    
    var touchedView = 0
    
    
    // Variable for tracking current scale.
    var currentScale: CGFloat = 1.0;
    
    // Flag for tracking of scaling up or down.
    var shouldScaleUp = false
    
    // Speed for scaling.
    let scaleSpeed: CGFloat = 0.5
    
    // For view sizing.
    let viewRadius: CGFloat = 50.0
    
    // Custom purple color.
    let greyColor = UIColor(red:0.01, green:0.01, blue:0.1, alpha:0.2)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Position
        var xOffset = viewRadius * 2.85
        var yOffset = viewRadius * 4.85;
        
        // Create scale view and make it a circle.
        scaleView = UIView(frame: CGRect(x: 0, y: 0, width: viewRadius * 2, height: viewRadius * 2))
        scaleView.layer.cornerRadius = viewRadius
        
        
        let uiImage = UIImage(named: "Thumbnail.JPG")!
        // Set background color.
        scaleView.backgroundColor = UIColor(patternImage: uiImage)
        
        // Center on parent view.
        scaleView.center = CGPoint(x: xOffset, y: yOffset)
        
        // Add to parent view.
        self.view.addSubview(scaleView)
        
        
        // Move y offset down.
        yOffset += viewRadius * 3.5;
        xOffset += viewRadius * 1.85
        
        
        //create second view
        scaleView2 = UIView(frame: CGRect(x: 0, y: 0, width: viewRadius * 2, height: viewRadius * 2))
        scaleView2.layer.cornerRadius = viewRadius
        scaleView2.center = CGPoint(x: xOffset, y: yOffset)
        let uiImage2 = UIImage(named: "daytime.JPG")!
        scaleView2.backgroundColor = UIColor(patternImage: uiImage2)
        self.view.addSubview(scaleView2)
        
        yOffset += viewRadius * 3.5;
        xOffset -= viewRadius * 1.85
        
        
        
        //create third view
        scaleView3 = UIView(frame: CGRect(x: 0, y: 0, width: viewRadius * 2, height: viewRadius * 2))
        scaleView3.layer.cornerRadius = viewRadius
        scaleView3.center = CGPoint(x: xOffset, y: yOffset)
        let uiImage3 = UIImage(named: "bird.JPG")!
        scaleView3.backgroundColor = UIColor(patternImage: uiImage3)
        self.view.addSubview(scaleView3)
        
        yOffset += viewRadius * 3.5;
        
        
        
        // Setup an the update loop.
        let displayLink = CADisplayLink(target: self, selector: #selector(updateLoop))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        
    }
    
    
    @objc
    func updateLoop(ViewTouched:UIView) {
        // Determine if scalingup or down based on flag.
        
        let value = shouldScaleUp ? scaleSpeed : -scaleSpeed
        
        // Scale up or down view.
        // Keep scale above 1.0 and 5.0
        currentScale = max(currentScale + value, 1.0)
        currentScale = min(currentScale, 2.5)
        
        
        // Scale view.
        
        
        
        if  touchedView == 1 {
            scaleView.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
            scaleView.alpha = 1.0
            scaleView2.alpha = 0.3
            scaleView3.alpha = 0.3
            
            
        } else if touchedView == 2 {
            scaleView2.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
            scaleView2.alpha = 1.0
            scaleView.alpha = 0.3
            scaleView3.alpha = 0.3
            
        } else if touchedView == 3 {
            scaleView3.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
            scaleView3.alpha = 1.0
            scaleView.alpha = 0.3
            scaleView2.alpha = 0.3
            
        }
        
        //        scaleView2.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
        //        scaleView3.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get first touch.
        
        
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
            
            
            // Process swipe pattern based on which hexagon is touched.
            if hitView == scaleView {
                shouldScaleUp = true
                touchedView = 1
                
                
            } else if hitView == scaleView2 {
                touchedView = 2
                shouldScaleUp = true
                
                
            } else if hitView == scaleView3 {
                touchedView = 3
                shouldScaleUp = true
                
            } else {
                touchedView = 0
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
            
            
            // Process swipe pattern based on which hexagon is touched.
            if hitView == scaleView {
                shouldScaleUp = false
                
                
            } else if hitView == scaleView2 {
                shouldScaleUp = false
                
                
            } else if hitView == scaleView3 {
                shouldScaleUp = false
                
                
            }
        }
        let secondViewController = storyboard?.instantiateViewController(withIdentifier: "nearbyAR")
        self.present(secondViewController!, animated: true, completion: nil)
        
    }
    
    
}

