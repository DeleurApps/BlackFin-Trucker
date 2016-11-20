//
//  JobInfoViewController.swift
//  OnCall Trucker
//
//  Created by Stiven Deleur on 11/19/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

import UIKit

class JobInfoViewController: UIViewController {
	
	var job: Job? = nil

	@IBOutlet weak var portNameLabel: UILabel!
	@IBOutlet weak var containerLabel: UILabel!
	@IBOutlet weak var terminalNameLabel: UILabel!
	@IBOutlet weak var destinationNameLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var compensationLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()

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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
