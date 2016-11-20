//
//  JobsViewController.swift
//  OnCall Trucker
//
//  Created by Stiven Deleur on 11/19/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

import UIKit
import Alamofire

class JobFilter{
	static let distancesStrings = ["Any", "< 5 miles", "5-20 miles", "20-50 miles", "50-150 miles", "150+ miles"]
	static let compensationsStrings = ["Any", "< $100", "$100-200", "$200-500", "$500-1000", "$1000+"]
	static let portsStrings = ["Any", "Los Angeles"]
	
	var timeFrom: Date
	var timeTo: Date
	var distance: Int
	var compensation: Int
	var port: Int
	
	init(timeFrom: Date, timeTo: Date, distance: Int, compensation: Int, port: Int){
		self.timeFrom = timeFrom
		self.timeTo = timeTo
		self.distance = distance
		self.compensation = compensation
		self.port = port
	}
	
}

class JobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	// MARK: UI Elements
	
	@IBOutlet weak var jobTableView: UITableView!
	var refreshControl: UIRefreshControl = UIRefreshControl()
	var allJobs: [Job] = []
	var filteredJobs: [Job] = []
	var filter = JobFilter(timeFrom: Date(), timeTo: Date(), distance: 0, compensation: 0, port: 0)
	

	
    override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(JobsViewController.receivedNewData), name: Notification.Name("JobsNetworkRequest"), object: nil)
		refreshControl.addTarget(self, action: #selector(JobsViewController.refreshTableView), for: UIControlEvents.valueChanged)
		jobTableView.addSubview(refreshControl)
		loadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? FilterViewController{
			vc.currentFilter = filter
		}
		// Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
		
	@IBAction func unwindGeneric(_: UIStoryboardSegue){
		//refreshTableView()
	}
	
	@IBAction func unwindAndFilter(_: UIStoryboardSegue){
		filterJobs()
		refreshTableView()
	}
	
	func openJobInfo(sender: UIButton){
		self.performSegue(withIdentifier: "openJobInfo", sender: sender)
	}

	
	// MARK: Table View Data Source
	
	func convertStringToDictionary(text: String) -> [String:AnyObject]? {
		if let data = text.data(using: String.Encoding.utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
			} catch let error as NSError {
				print(error)
			}
		}
		return nil
	}
	
	func refreshTableView(){
		refreshControl.beginRefreshing();
		loadData()
	}
	
	func loadData(){
		DataHandler.makeGetRequest(endpoint: "jobs", notificationName: "JobsNetworkRequest")
	}
	
	func jobBetweenTimes(_ job: Job) -> Bool{
		let fromTime = filter.timeFrom
		var toTime = filter.timeTo
		var jobTime = job.time
		
		let timeBetween = fromTime.timeIntervalSince(toTime)
		toTime += timeBetween - timeBetween.truncatingRemainder(dividingBy: 86400)
		
		if timeBetween > -1 {
			toTime += 86400
		}
		
		let timeSince = fromTime.timeIntervalSince(jobTime)
		
		jobTime += timeSince - timeSince.truncatingRemainder(dividingBy: 86400)
		
		if jobTime < fromTime {
			jobTime += 86400
		}
		
		if jobTime >= fromTime && jobTime <= toTime{
			return true
		}else{
			return false
		}
	}
	
	func jobCompensationInRange(_ job: Job) -> Bool{
		if filter.compensation == 0{
			return true
		}
		switch job.compensation{
		case 0..<100:
			if filter.compensation == 1{
				return true
			}else{
				return false
			}
		case 100..<200:
			if filter.compensation == 2{
				return true
			}else{
				return false
			}
		case 200..<500:
			if filter.compensation == 3{
				return true
			}else{
				return false
			}
		case 500..<1000:
			if filter.compensation == 4{
				return true
			}else{
				return false
			}
		default:
			if filter.compensation == 5{
				return true
			}else{
				return false
			}
		}
	}
	
	func filterJobs(){
		
			filteredJobs = allJobs.filter { job in
				return jobBetweenTimes(job)
					&& (filter.distance == 0 || false)
					&& (jobCompensationInRange(job))
					&& (filter.port == 0 || job.port == JobFilter.portsStrings[filter.port])
			}
	}
	
	func receivedNewData(notification: Notification){
		refreshControl.endRefreshing();
		if let result:Result<Any> = notification.userInfo!["result"] as? Result<Any> {
			if let JSON = result.value as? NSArray {
				for element in JSON{
					if let jobDict:NSDictionary = element as? NSDictionary {
						// Set date format
						let dateFmt = DateFormatter()
						dateFmt.timeZone = NSTimeZone.default
						dateFmt.locale = Locale(identifier: "en_US_POSIX")
						dateFmt.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
						
						let dateStr = jobDict.value(forKey: "arrival_time") as? String ?? "2000-01-01T00:00:00.000Z"
						// Get NSDate for the given string
						let date = dateFmt.date(from: dateStr)
						
						let job = Job(port: jobDict.value(forKey: "port") as? String ?? "Port",
						              jobid: jobDict.value(forKey: "id") as? Int64 ?? 0,
						              containerid: jobDict.value(forKey: "container_id") as? String ?? "XXXX9999999",
						              containerSize: jobDict.value(forKey: "container_size") as? Int64 ?? 0,
						              time: date!,
						              terminal: jobDict.value(forKey: "terminal") as? String ?? "Terminal",
						              destination: jobDict.value(forKey: "destination") as? String ?? "City",
						              compensation: jobDict.value(forKey: "price") as? Double ?? 0)
						allJobs.append(job)
						
					}
					
				}
			}
		}
		filterJobs()
		jobTableView.reloadData();
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return filteredJobs.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell")!
		let job = filteredJobs[indexPath.item]
		let portNameLabel = cell.viewWithTag(1) as! UILabel
		let containerLabel = cell.viewWithTag(2) as! UILabel
		let pickupTimeLabel = cell.viewWithTag(3) as! UILabel
		let destinationLabel = cell.viewWithTag(4) as! UILabel
		let priceLabel = cell.viewWithTag(5) as! UILabel
		
		let dateFmt = DateFormatter()
		dateFmt.locale = Locale(identifier: "en_US_POSIX")
		
		dateFmt.dateFormat = "EEE, MMM dd - hh:mma"
	
		portNameLabel.text = job.port
		containerLabel.text = "Container #: " + job.containerid
		pickupTimeLabel.text = "Pickup Time: " + dateFmt.string(from: job.time)
		destinationLabel.text = "Destination: " + job.destination
		priceLabel.text = "$" + String(format: "%0.2f", job.compensation)
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(JobsViewController.openJobInfo(sender:)))
		
		cell.addGestureRecognizer(tapGesture)
		return cell
	}
	

}
