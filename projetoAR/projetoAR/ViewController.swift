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
		
		//let scene = SCNScene(named: "scene.scnassets/jenga.scn")!
		let scene = SCNScene(named: "scene.scnassets/block.scn")!

		sceneView.scene = scene
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
		
		view.addGestureRecognizer(tapGesture)
		
		let coachingView = ARCoachingOverlayView(frame: self.view.frame)
		coachingView.delegate = self
		self.view.addSubview(coachingView)
		
	}
	
	@objc func handleTap(sender:UITapGestureRecognizer){
		
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		setConfiguration()
		
		sceneView.session.delegate = self
		sceneView.showsStatistics = true
		
	}
	
	func setConfiguration(){
		// Create a session configuration
		let configuration = ARWorldTrackingConfiguration()
		configuration.planeDetection = .horizontal
		
		// Run the view's session
		sceneView.session.run(configuration)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Pause the view's session
		sceneView.session.pause()
	}
}

extension ViewController:ARSCNViewDelegate{
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		
		let plane = Plane(anchor: planeAnchor, in: sceneView)
		node.addChildNode(plane)


	}
}
extension ViewController: ARSessionDelegate{
	
}

