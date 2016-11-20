//
//  Job.swift
//  OnCall Trucker
//
//  Created by Stiven Deleur on 11/19/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

import Foundation

struct Job{
	var port: String
	var jobid: Int64
	var containerid: String
	var containerSize: Int64
	var time: Date
	var terminal: String
	var destination: String
	var compensation: Double
}
