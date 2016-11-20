//
//  Authorization.swift
//  OnCall Trucker
//
//  Created by Stiven Deleur on 11/20/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

import Foundation
import Alamofire

struct Trucker{
	var id: Int64
	var name: String
	var jobs: [Job]
	
}
class Authorization{
	static var trucker: Trucker = Trucker(id: 0, name: "Trucker Name", jobs: [])
	
	class func signIn(truckerid: String){
		DataHandler.makePostRequest(endpoint: "getTruckerInfo", params: ["trucker_id": truckerid], notificationName: "TruckerNetworkRequest")
	}
	class func processNetworkResponse(notification: Notification){
		//DispatchQueue.global(qos: .background).async {
		if let result:Result<Any> = notification.userInfo!["result"] as? Result<Any> {
			if let info = result.value as? NSDictionary {
				let truckerid = info.value(forKey: "id") as! Int64
				let truckername = info.value(forKey: "name") as! String
				let truckerJobs : NSArray = info.value(forKey: "jobs") as! NSArray
				var jobs = [Job]()
				for element in truckerJobs{
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
						              compensation: jobDict.value(forKey: "price") as? Double ?? 0,
						              truckerid: jobDict.value(forKey: "trucker_id") as? Int64,
						              isFinished: jobDict.value(forKey: "is_finished") as? Bool ?? false)
						jobs.append(job)
					}
					
				}
				let trucker = Trucker(id: truckerid, name: truckername, jobs: jobs)
				Authorization.trucker = trucker
				Authorization.trucker.jobs.sort{
					return $0.time < $1.time
				}
			}
		}
		//}
	}
	
	
}
