//
//  JobsViewController.swift
//  OnCall Trucker
//
//  Created by Stiven Deleur on 11/20/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

import UIKit
import Alamofire


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	// MARK: UI Elements
	
	@IBOutlet weak var jobTableView: UITableView!
	@IBOutlet weak var truckerNameLabel: UINavigationItem!
	var refreshControl: UIRefreshControl = UIRefreshControl()
	//var allJobs: [Job] = []
	//var filteredJobs: [Job] = []
	//var filter = JobFilter(timeFrom: Date(), timeTo: Date(), distance: 0, compensation: 0, port: 0)
	//var activityIndicator: BlackfinActivityIndicator? = nil
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		truckerNameLabel.title = Authorization.trucker.name
		//activityIndicator = BlackfinActivityIndicator(superview: self.view)
		//NotificationCenter.default.addObserver(self, selector: #selector(JobsViewController.receivedNewData), name: Notification.Name("JobsNetworkRequest"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.receivedTruckerInfo), name: Notification.Name("TruckerNetworkRequest"), object: nil)
		refreshControl.addTarget(self, action: #selector(ProfileViewController.refreshTableView), for: UIControlEvents.valueChanged)
		jobTableView.addSubview(refreshControl)
		//activityIndicator?.animate()
		//loadData()
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if let vc = segue.destination as? FilterViewController{
//			vc.currentFilter = filter
//		}else 
		if let vc = segue.destination as? JobInfoViewController{
			vc.job = Authorization.trucker.jobs[((sender as! UITapGestureRecognizer).view?.tag)!]
		}
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
	}
	
	@IBAction func unwindGeneric(_: UIStoryboardSegue){
		//refreshTableView()
	}
	
//	@IBAction func unwindAndFilter(_: UIStoryboardSegue){
//		filterJobs()
//	}
	
	func openJobInfo(sender: Any?){
		self.performSegue(withIdentifier: "openTruckerJobInfo", sender: sender)
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
		refreshControl.beginRefreshing()
		Authorization.signIn(truckerid: String(Authorization.trucker.id))
	}
	
//	func loadData(){
//		DataHandler.makeGetRequest(endpoint: "jobs", notificationName: "JobsNetworkRequest")
//	}
	
//	func jobBetweenTimes(_ job: Job) -> Bool{
//		let fromTime = filter.timeFrom
//		var toTime = filter.timeTo
//		var jobTime = job.time
//		
//		let timeBetween = fromTime.timeIntervalSince(toTime)
//		toTime += timeBetween - timeBetween.truncatingRemainder(dividingBy: 86400)
//		
//		if timeBetween > -1 {
//			toTime += 86400
//		}
//		
//		let timeSince = fromTime.timeIntervalSince(jobTime)
//		
//		jobTime += timeSince - timeSince.truncatingRemainder(dividingBy: 86400)
//		
//		if jobTime < fromTime {
//			jobTime += 86400
//		}
//		
//		if jobTime >= fromTime && jobTime <= toTime{
//			return true
//		}else{
//			return false
//		}
//	}
//	
//	func jobCompensationInRange(_ job: Job) -> Bool{
//		if filter.compensation == 0{
//			return true
//		}
//		switch job.compensation{
//		case 0..<100:
//			if filter.compensation == 1{
//				return true
//			}else{
//				return false
//			}
//		case 100..<200:
//			if filter.compensation == 2{
//				return true
//			}else{
//				return false
//			}
//		case 200..<500:
//			if filter.compensation == 3{
//				return true
//			}else{
//				return false
//			}
//		case 500..<1000:
//			if filter.compensation == 4{
//				return true
//			}else{
//				return false
//			}
//		default:
//			if filter.compensation == 5{
//				return true
//			}else{
//				return false
//			}
//		}
//	}
//	
//	func filterJobs(){
//		activityIndicator?.animate()
//		filteredJobs = allJobs.filter { job in
//			return jobBetweenTimes(job)
//				&& (filter.distance == 0 || false)
//				&& (jobCompensationInRange(job))
//				&& (filter.port == 0 || job.port == JobFilter.portsStrings[filter.port])
//		}
//		jobTableView.reloadData();
//		activityIndicator?.stopAnimation()
//	}
	
	func receivedTruckerInfo(notification: Notification){
		refreshControl.endRefreshing()
		Authorization.processNetworkResponse(notification: notification)
		truckerNameLabel.title = Authorization.trucker.name
		jobTableView.reloadData()
	}

	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return Authorization.trucker.jobs.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell")!
		let job = Authorization.trucker.jobs[indexPath.item]
		let portNameLabel = cell.viewWithTag(100000001) as! UILabel
		let containerLabel = cell.viewWithTag(100000002) as! UILabel
		let pickupTimeLabel = cell.viewWithTag(100000003) as! UILabel
		let destinationLabel = cell.viewWithTag(100000004) as! UILabel
		let priceLabel = cell.viewWithTag(100000005) as! UILabel
		let statusLabel = cell.viewWithTag(100000006) as! UILabel
		
		let dateFmt = DateFormatter()
		dateFmt.locale = Locale(identifier: "en_US_POSIX")
		
		dateFmt.dateFormat = "EEE, MMM dd - hh:mma"
		
		portNameLabel.text = job.port + " Port"
		containerLabel.text = "Container #: " + job.containerid
		pickupTimeLabel.text = "Pickup Time: " + dateFmt.string(from: job.time)
		destinationLabel.text = "Destination: " + job.destination
		priceLabel.text = "$" + String(format: "%0.2f", job.compensation)
		
		if (job.isFinished){
			statusLabel.text = "Completed"
			statusLabel.textColor = UIColor.green
		}else{
			if (job.time > Date()){
				statusLabel.text = "Scheduled"
				statusLabel.textColor = UIColor.red
			}else{
				statusLabel.text = "In Progress"
				statusLabel.textColor = UIColor.orange
			}
		}
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(JobsViewController.openJobInfo(sender:)))
		
		cell.addGestureRecognizer(tapGesture)
		
		cell.tag = indexPath.item
		return cell
	}
	
	
}
