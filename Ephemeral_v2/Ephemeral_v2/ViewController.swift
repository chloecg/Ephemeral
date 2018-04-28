//
//  ViewController.swift
//  Ephemeral_v2
//
//  Created by Chang Gao on 4/25/18.
//  Copyright © 2018 Ephemeral. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation



class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate, SCNSceneRendererDelegate{
    
    @IBOutlet var sceneView: ARSCNView!
    
    var ships: [Ship] = [Ship]()
    let humanPosition = SCNVector3(2, -1, -5)
    
    
    //var t2:Bool = true
    
//    let locationManager = CLLocationManager()
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled(){
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//        }
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
    
        loadHuman()
        
        loadBirds()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first{
//            print(location.coordinate)
////            let location1 = CLLocation(latitude: 24.953232, longitude: 121.225353)
//            let location2 = CLLocation(latitude: 40.7292, longitude: 74.0113)
//            let distanceInMeters : CLLocationDistance = location.distance(from: location2)
//            if(distanceInMeters <= 1609)
//            {
//                loadAnimations()
//                print("under 1 mile")
//                // under 1 mile
//            }
//            else
//            {
//                print("out of 1 mile")
//                // out of 1 mile
//            }
//        }
//
//
//
//
//    }
    
    
    
    func loadHuman () {
        
        // Load the character in the idle animation
        let waveScene = SCNScene(named: "art.scnassets/desls_sa.dae")!
        
        // This node will be parent of all the animation models
        let node = waveScene.rootNode.childNode(withName: "desls_sa", recursively: true)!
        
        sceneView.scene.rootNode.addChildNode(node)
        
        // Set up some properties
        node.position = humanPosition
        node.scale = SCNVector3(0.8, 0.8, 0.8)
        
    }
    
    func loadBirds () {
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/bird.dae")!
        
//        let realGameScene = SCNScene();
        
        //
        // retrieve the ship node
        for _ in 0...35
        {
            let shipNode = scene.rootNode.childNode(withName: "bird", recursively: true)!.clone()
            
            let ship = Ship(newNode: shipNode);
            sceneView.scene.rootNode.addChildNode(ship.node)
            ships.append(ship);
            ship.node.position = SCNVector3(
                x: humanPosition.x+Float(Int(arc4random_uniform(10)) - 5)/100,
                y: humanPosition.y+Float(Int(arc4random_uniform(10)) - 5)/100,
                z: humanPosition.z+Float(Int(arc4random_uniform(10)) - 5)/100 - 5)
            ship.node.scale = SCNVector3(x: Float(10), y: Float(10), z: Float(10))
            
        }

        
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
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MARK: - SCNSceneRendererDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    {
        let percievedCenter = humanPosition
        var percievedVelocity = SCNVector3(x: Float(CGFloat(0)), y: Float(CGFloat(0)), z:Float(CGFloat(0)))
        for otherShip in ships
        {
            // percievedCenter = percievedCenter + otherShip.node.position;
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

}
