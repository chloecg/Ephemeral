//
//  ViewController.swift
//  Flocking
//
//  Created by Chang Gao on 4/26/18.
//  Copyright © 2018 Ephemeral. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate,SCNSceneRendererDelegate{

    @IBOutlet var sceneView: ARSCNView!
    
    var ships: [Ship] = [Ship]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/bird.dae")!
        
        let realGameScene = SCNScene();
        
//
        // retrieve the ship node
        for _ in 0...35
        {
            let shipNode = scene.rootNode.childNode(withName: "bird", recursively: true)!.clone()
            
            let ship = Ship(newNode: shipNode);
            realGameScene.rootNode.addChildNode(ship.node)
            ships.append(ship);
            ship.node.position = SCNVector3(x: Float(Int(arc4random_uniform(10)) - 5), y: Float(Int(arc4random_uniform(10)) - 5), z: 10.0)
            ship.node.scale = SCNVector3(x: Float(10), y: Float(10), z: Float(10))
            
        }
        
//
//        let shipNode = scene.rootNode.childNode(withName: "bird", recursively: true)!.clone()
//        shipNode.position = SCNVector3(x: Float(-100), y: Float(-100), z: Float(10))
//        realGameScene.rootNode.addChildNode(shipNode)
//        let animation = CABasicAnimation(keyPath: "rotation")
//        animation.toValue = NSValue(scnVector4: SCNVector4(x: Float(0), y: Float(1), z: Float(0), w: Float(M_PI)*2))
//        animation.duration = 30000
//        animation.repeatCount = MAXFLOAT //repeat forever
//        shipNode.addAnimation(animation, forKey: nil)
//
        // Set the view's delegate
        sceneView.delegate = self
        
        // show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // set the scene to the view
        sceneView.scene = realGameScene
        

        
        
    }
    
//    func degToRad(_ deg: CGFloat) -> CGFloat {
//        return deg / 180.0 * CGFloat(M_PI)
//    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    {
        var percievedCenter = SCNVector3(x: Float(CGFloat(0)), y: Float(CGFloat(0)), z:Float(CGFloat(0)))
        var percievedVelocity = SCNVector3(x: Float(CGFloat(0)), y: Float(CGFloat(0)), z:Float(CGFloat(0)))
        for otherShip in ships
        {
            percievedCenter = percievedCenter + otherShip.node.position;
            percievedVelocity = percievedVelocity + otherShip.velocity;
        }
        
        for ship in ships
        {
            var v1 = flyCenterOfMass(ship, percievedCenter)
            var v2 = keepASmallDistance(ship)
            var v3 = matchSpeedWithOtherShips(ship, percievedVelocity)
            var v4 = boundPositions(ship)
            
            
            v1 *= (0.01)
            v2 *= (0.01)
            v3 *= (0.01)
            v4 *= (1.0)
            
            let forward = SCNVector3(x: Float(CGFloat(0)), y: Float(CGFloat(0)), z: Float(CGFloat(1)))
            let velocityNormal = ship.velocity.normalized()
            ship.velocity = ship.velocity + v1 + v2 + v3 + v4;
            limitVelocity(ship);
            let nor = forward.cross(velocityNormal)
            let angle = CGFloat(forward.dot(velocityNormal))
            ship.node.rotation = SCNVector4(x: nor.x, y: nor.y, z: nor.z, w: Float(CGFloat(acos(angle))))
            ship.node.position = ship.node.position + (ship.velocity)
        }
    }
    
    func limitVelocity(_ ship: Ship)
    {
        let mag = Float(ship.velocity.length())
        let limit = Float(0.5);
        if mag > limit
        {
            ship.velocity = (ship.velocity/mag) * limit
        }
        
        
    }
    
    func flyCenterOfMass(_ ship: Ship, _ percievedCenter: SCNVector3) -> SCNVector3
    {
        
        let averagePercievedCenter = percievedCenter / Float(ships.count - 1);
        
        return (averagePercievedCenter - ship.node.position)/100;
        
    }
    
    func keepASmallDistance(_ ship: Ship) -> SCNVector3
    {
        var forceAway = SCNVector3(x: Float(CGFloat(0)), y: Float(CGFloat(0)), z:Float(CGFloat(0)))
        
        for otherShip in ships
        {
            if ship.node != otherShip.node
            {
                if abs(otherShip.node.position.distance(ship.node.position)) < 5
                {
                    forceAway = (forceAway - (otherShip.node.position - ship.node.position))
                }
            }
        }
        
        return forceAway
        
    }
    
    func matchSpeedWithOtherShips(_ ship: Ship,  _ percievedVelocity: SCNVector3) -> SCNVector3 {
        
        let averagePercievedVelocity = percievedVelocity / Float(ships.count - 1);
        
        return (averagePercievedVelocity - ship.velocity)
    }
    
    func boundPositions(_ ship: Ship) -> SCNVector3 {
        var rebound = SCNVector3(x: Float(CGFloat(0)), y: Float(CGFloat(0)), z:Float(CGFloat(0)))
        
        let Xmin = -30;
        let Ymin = -30;
        let Zmin = -30;
        
        let Xmax = 30;
        let Ymax = 30;
        let Zmax = 70;
        
        if ship.node.position.x < Float(CGFloat(Xmin))
        {
            rebound.x = 1;
        }
        
        if ship.node.position.x > Float(CGFloat(Xmax))
        {
            rebound.x = -1;
        }
        
        if ship.node.position.y < Float(CGFloat(Ymin))
        {
            rebound.y = 1;
        }
        
        if ship.node.position.y > Float(CGFloat(Ymax))
        {
            rebound.y = -1;
        }
        
        if ship.node.position.z < Float(CGFloat(Zmin))
        {
            rebound.z = 1;
        }
        
        if ship.node.position.z > Float(CGFloat(Zmax))
        {
            rebound.z = -1;
        }
        
        return rebound;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
        
    
}
