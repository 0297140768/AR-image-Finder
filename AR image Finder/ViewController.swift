//
//  ViewController.swift
//  AR image Finder
//
//  Created by Татьяна on 23.09.2018.
//  Copyright © 2018 Татьяна. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene() //SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        let referenceImage = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!

        configuration.detectionImages = referenceImage
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        switch anchor {
        case let imageAnchor as ARImageAnchor:
            nodeAdded(node, for: imageAnchor)
        case let planeAnchor as ARPlaneAnchor:
            nodeAdded(node, for: planeAnchor)
        default:
            print("Нашли якорь, но это не плоскость и не картинка")
        }
    }
    
    func nodeAdded(_ node: SCNNode, for imageAnchor: ARImageAnchor) {
        let referenceImage = imageAnchor.referenceImage
        var nodeName = ""
        var koef: Float = 1
        
        switch referenceImage.name {
        case "IMG_3518":
            nodeName = "Book"
            koef = 2
        case "IMG_3519":
            nodeName = "TV"
            koef = 0.5
        default:
            break
        }
        
        let itemNode = SCNScene(named: "art.scnassets/\(nodeName).scn")?.rootNode.childNode(withName: nodeName, recursively: false)!
        itemNode?.eulerAngles.x = -Float.pi / 2
        itemNode?.eulerAngles.y = -Float.pi / 4
        
        let scale = Float(referenceImage.physicalSize.width) / (itemNode!.boundingBox.max.z * koef)
        itemNode?.scale = SCNVector3(scale, scale, scale)
        
        if referenceImage.name == "IMG_3518" {
            itemNode?.position.y = itemNode!.boundingBox.max.x * scale
        }
        
        node.addChildNode(itemNode!)
        
    }
    
    func nodeAdded(_ node: SCNNode, for planAnchor: ARPlaneAnchor) {
        
    }
    
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
