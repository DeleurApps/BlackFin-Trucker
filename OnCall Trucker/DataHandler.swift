//
//  DataHandler.swift
//  
//
//  Created by Samuel Resendez on 11/19/16.
//
//

import Alamofire

class DataHandler: NSObject {
    
	class func makeGetRequest(endpoint:String, notificationName:String?) {
        Alamofire.request("http://oncallbackend.herokuapp.com/"+endpoint, method:.get).responseJSON {
			response in
			let responseDict : [String : Any?] = ["request": response.request, "response": response.response, "data": response.data, "result": response.result ]
			if let name = notificationName {
				NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: responseDict)
			}
        }

    }
    class func makePostRequest(endpoint:String, params:Parameters, notificationName:String?) {
        Alamofire.request("http://oncallbackend.herokuapp.com/"+endpoint, method:.post, parameters:params).responseJSON { response in
			let responseDict : [String : Any?] = ["request": response.request, "response": response.response, "data": response.data, "result": response.result ]
			if let name = notificationName {
				NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: responseDict)
			}
        }
    }
}
