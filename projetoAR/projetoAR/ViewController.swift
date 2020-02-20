//
//  ViewController.swift
//  projetoAR
//
//  Created by Pietro Pugliesi on 17/02/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARCoachingOverlayViewDelegate{

	@IBOutlet weak var sceneView: ARSCNView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setConfiguration()
		sceneView.delegate = self
		sceneView.session.delegate = self
		sceneView.showsStatistics = true
		
		
		let scene = SCNScene()
		sceneView.scene = scene
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
		
		view.addGestureRecognizer(tapGesture)
		
		let coachingView = ARCoachingOverlayView(frame: self.view.frame)
		coachingView.delegate = self
		coachingView.goal = .horizontalPlane
		coachingView.activatesAutomatically = true
		self.view.addSubview(coachingView)
		
	}
	
	@objc func handleTap(sender:UITapGestureRecognizer){
		let touchLocation = sender.location(in: sceneView)
		let hitTest = sceneView.hitTest(touchLocation)
		if !hitTest.isEmpty{
			let result = hitTest.first!
			let name = result.node
			let geometry = result.node.geometry
			print("tapped \(name) eith geometry \(geometry)")
			
		}
		
	}
	
	
	func createNode(nodeName:String, position: SCNVector3){
		let boxScene = SCNScene(named: "scene.scnassets/block.scn")!
		let boxNode = boxScene.rootNode.childNode(withName: nodeName, recursively: true)!
		boxNode.position = position
		sceneView.scene.rootNode.addChildNode(boxNode)
		
	}
	
	func setConfiguration(){
		// Create a session configuration
		let configuration = ARWorldTrackingConfiguration()
		configuration.planeDetection = .horizontal
		
		
		// Run the view's session
		sceneView.session.run(configuration)
		sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Pause the view's session
		sceneView.session.pause()
	}
}

extension ViewController:ARSCNViewDelegate{
	
	func createFloor(anchor:ARPlaneAnchor)->SCNNode{
		let floor = SCNNode()
		floor.name = "floor"
		floor.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
		floor.geometry?.firstMaterial?.diffuse.contents = UIColor.green
		floor.geometry?.firstMaterial?.isDoubleSided = true
		floor.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
		
		floor.eulerAngles.x = -.pi/2
		return floor
	}
	
	func removeNode(named:String){
		sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
			if node.name == named{
				node.removeFromParentNode()
			}
		}
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
		let floor = createFloor(anchor: planeAnchor)
		node.addChildNode(floor)
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
		removeNode(named: "floor")
		let floor = createFloor(anchor: planeAnchor)
		node.addChildNode(floor)
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
		print("plano removido \(planeAnchor.extent)")
		removeNode(named: "floor")
	}
}

extension ViewController: ARSessionDelegate{
	
}

