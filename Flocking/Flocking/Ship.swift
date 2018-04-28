

import SceneKit
import QuartzCore

class Ship{
    
    var node: SCNNode;
    var velocity: SCNVector3 = SCNVector3(x: Float(CGFloat(1)), y: Float(CGFloat(1)), z:Float(CGFloat(1)))
    var prevDir: SCNVector3 = SCNVector3(x: Float(CGFloat(0)), y: Float(CGFloat(1)), z:Float(CGFloat(0)))
    
    init(newNode: SCNNode)
    {
        self.node = newNode;
    }
}

