//
//  ViewController.swift
//  sitPose
//
//  Created by Chang Gao on 4/27/18.
//  Copyright © 2018 Ephemeral. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let humanPosition = SCNVector3(2, -1, -10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        
        // Load Model
        loadModel()
        //loadLeaf()
        loadParticle()
    }

    func loadModel () {
        
        // Load the character in the idle animation
        let waveScene = SCNScene(named: "art.scnassets/sitsad.dae")!
        
        // This node will be parent of all the animation models
        let node = waveScene.rootNode.childNode(withName: "sitsad", recursively: true)!
        
        sceneView.scene.rootNode.addChildNode(node)
        
        // Set up some properties
        node.position = humanPosition
        node.scale = SCNVector3(2, 2, 2)
        
    }
    
    private func loadLeaf() {
        if let scene = LeafSimulationScene(fileNamed:"LeafSimulationScene") {
            // Configure the view.
            //let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            //skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .aspectFill
            
            // Make the scene the same size as the scene's SKView
            //scene.size = CGSize(width: 1.0, height: 1.0)//skView.bounds.size
            //sceneView.scene.rootNode.addChildNode(scene)
            //skView.presentScene(scene)
        }
    }
    
    func loadParticle(){
        //let scene = SCNScene(named: "rainParticles.sks")
        
        let particlesNode = SCNNode()
        let particleSystem = SCNParticleSystem(named: "bokehParticle", inDirectory: "")
        particlesNode.addParticleSystem(particleSystem!)
        particlesNode.position = SCNVector3(humanPosition.x, humanPosition.y + 2.5, humanPosition.z - 0.5)
        particlesNode.scale = SCNVector3(0.25, 0.25, 0.25)
        //particlesNode.rotation = SCNVector4(0, 0, 1, CGFloat.pi)
        sceneView.scene.rootNode.addChildNode(particlesNode)
        
        
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
