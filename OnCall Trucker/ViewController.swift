//
//  ViewController.swift
//  OnCall Trucker
//
//  Created by Stiven Deleur on 11/19/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

	@IBOutlet weak var usernameTextField: UITextField!
	let truckerID = "10"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receivedTruckerInfo), name: Notification.Name("TruckerNetworkRequest"), object: nil)
		// Do any additional setup after loading the view, typically from a nib.
	}
	@IBAction func signIn(_ sender: UIButton) {
		Authorization.signIn(truckerid: truckerID)
	}
	
	func receivedTruckerInfo(notification: Notification){
		Authorization.processNetworkResponse(notification: notification)
		NotificationCenter.default.removeObserver(self)
	}

}

