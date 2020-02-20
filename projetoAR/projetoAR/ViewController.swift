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
	
	var didSelectPlane = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setConfiguration()
		sceneView.delegate = self
		sceneView.session.delegate = self
		sceneView.showsStatistics = true
		
		
		let scene = SCNScene()
		sceneView.scene = scene
		
		let coachingView = ARCoachingOverlayView(frame: self.view.frame)
		coachingView.delegate = self
		coachingView.goal = .horizontalPlane
		coachingView.activatesAutomatically = true
		self.view.addSubview(coachingView)
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.setTouch(touch: touches.first!)
	}
	
	func setTouch(touch:UITouch){
		let touchLocation = touch.location(in: sceneView)
		let result = sceneView.hitTest(touchLocation, types: .existingPlaneUsingGeometry)
		
		if !result.isEmpty{
			guard let hitResult = result.first else{return}
			let position = hitResult.worldTransform.columns.3
			
			let x = position.x
			let y = position.y
			let z = position.z
			
			createNode(nodeName: "box",position: SCNVector3(x, y, z))
		}
	}
	
	
	func createNode(nodeName:String,position:SCNVector3){
		let boxScene = SCNScene(named: "scene.scnassets/jenga.scn")!
//		let boxNode = boxScene.rootNode.childNode(withName: nodeName, recursively: false)!
		let sceneNode = boxScene.rootNode.childNode(withName: "sceneNode", recursively: true)!
		
		sceneNode.eulerAngles.x = .pi / 2
		
		let selectedPlane = sceneView.scene.rootNode.childNode(withName: "floor", recursively: true)!
		selectedPlane.addChildNode(sceneNode)
//		plane.addChildNode(boxNode)
		
		didSelectPlane = true
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
		floor.physicsBody?.type = .static
	
		floor.physicsBody?.isAffectedByGravity = true
		
		floor.eulerAngles.x = -.pi/2
		floor.scale = SCNVector3(0.3, 0.3, 0.3)
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
		if !didSelectPlane{
			guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
			let floor = createFloor(anchor: planeAnchor)
			node.addChildNode(floor)
		}
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		if !didSelectPlane{
			guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
			removeNode(named: "floor")
			let floor = createFloor(anchor: planeAnchor)
			node.addChildNode(floor)
		}
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
		print("plano removido \(planeAnchor.extent)")
		removeNode(named: "floor")
	}
}

extension ViewController: ARSessionDelegate{
	
}

