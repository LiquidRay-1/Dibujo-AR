//
//  ViewController.swift
//  clase2AR
//
//  Created by dam2 on 8/5/24.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        
        self.sceneView.delegate = self
    }
    

    @IBOutlet weak var button: UIButton!
    
    
    @IBAction func offButton(_ sender: Any) {
        self.sceneView.session.pause()
        
        self.sceneView.scene.rootNode.enumerateChildNodes{(node, _) in
            if node.name != "Yusepe" {
                node.removeFromParentNode()
            }
        }
        
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: any SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3( -transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let frontOfCamera = orientation + location
        
        DispatchQueue.main.async {
            
            if self.button.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = frontOfCamera
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            } else {
                let pointer = SCNNode(geometry: SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.01))
                pointer.name = "Ball"
                pointer.position = frontOfCamera
                
                self.sceneView.scene.rootNode.enumerateChildNodes( {(node, _) in
                    if node.name == "Ball" {
                        node.removeFromParentNode()
                    }
                })
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
        
    }
}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
}
