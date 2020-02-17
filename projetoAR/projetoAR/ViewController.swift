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

class ViewController: UIViewController, ARSCNViewDelegate {

	@IBOutlet weak var sceneView: ARSCNView!
	override func viewDidLoad() {
		super.viewDidLoad()
		sceneView.delegate = self
		sceneView.showsStatistics = true
		let scene = SCNScene(named: "scene.scnassets/scene.scn")!
		
		sceneView.scene = scene
		
		
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
		
		view.addGestureRecognizer(tapGesture)
		
	}
	
	@objc func handleTap(sender:UITapGestureRecognizer){
		let node = f
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
}

