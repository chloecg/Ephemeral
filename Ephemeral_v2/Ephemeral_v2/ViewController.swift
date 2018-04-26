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



class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var sceneView: ARSCNView!
    
    var t2:Bool = true
    
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
        
        // Load the DAE animations
        loadAnimations()
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
    
    
    
    func loadAnimations () {
        
        // Load the character in the idle animation
        let waveScene = SCNScene(named: "art.scnassets/desls_sa.dae")!
        
        // This node will be parent of all the animation models
        let node = waveScene.rootNode.childNode(withName: "desls_sa", recursively: true)!
        
        sceneView.scene.rootNode.addChildNode(node)
        
        // Set up some properties
        node.position = SCNVector3(2, -1, -5)
        node.scale = SCNVector3(0.8, 0.8, 0.8)
        
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
}
