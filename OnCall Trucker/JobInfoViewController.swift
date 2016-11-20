//
//  JobInfoViewController.swift
//  OnCall Trucker
//
//  Created by Stiven Deleur on 11/19/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

import UIKit
import Alamofire

class JobInfoViewController: UIViewController {
	
	var job: Job? = nil

	@IBOutlet weak var portNameLabel: UILabel!
	@IBOutlet weak var containerLabel: UILabel!
	@IBOutlet weak var terminalNameLabel: UILabel!
	@IBOutlet weak var destinationNameLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var compensationLabel: UILabel!
	@IBOutlet weak var reserveButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(JobInfoViewController.receivedReserveJobResponse), name: Notification.Name("ReserveJobNetworkRequest"), object: nil)
		
		let dateFmt = DateFormatter()
		dateFmt.locale = Locale(identifier: "en_US_POSIX")
		
		dateFmt.dateFormat = "EEE, MMM dd - hh:mma"
		
		portNameLabel.text = job?.port
		containerLabel.text = "Container #: " + (job?.containerid)!
		terminalNameLabel.text = job?.port
		timeLabel.text = "Pickup Time: " + dateFmt.string(from: (job?.time)!)
		destinationNameLabel.text = "Destination: " + (job?.destination)!
		compensationLabel.text = "$" + String(format: "%0.2f", (job?.compensation)!)
		
        // Do any additional setup after loading the view.
    }

	@IBAction func reserveJob(_ sender: UIButton) {
		DataHandler.makePostRequest(endpoint: "fillJob", params: ["trucker_id": 10, "job_id": job?.jobid ?? 0], notificationName: "ReserveJobNetworkRequest")
	}
	
	func receivedReserveJobResponse(notification: Notification){
		if let response:HTTPURLResponse = notification.userInfo!["response"] as? HTTPURLResponse, response.statusCode == 200 {
			reserveButton.backgroundColor = UIColor.green
			reserveButton.setTitle("SUCCESS", for: UIControlState.normal)
		}else{
			reserveButton.backgroundColor = UIColor.red
			reserveButton.setTitle("FAILED", for: UIControlState.normal)
		}
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
			self.performSegue(withIdentifier: "unwindFromJobInfo", sender: self)
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
