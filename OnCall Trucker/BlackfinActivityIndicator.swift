//
//  BlackfinActivityIndicator.swift
//  OnCall Trucker
//
//  Created by Stiven Deleur on 11/20/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

import UIKit

class BlackfinActivityIndicator: NSObject {
	var superview: UIView
	var view: UIView
	var dolphinImageView: UIView
	var animated: Bool = false
	
	init(superview: UIView) {
		self.superview = superview
		view = UIView(frame: superview.frame)
		let dolphinImage = UIImage(named: "DolphinLoading")
		let overlay = UIView(frame: superview.frame)
		overlay.backgroundColor = UIColor.black
		overlay.alpha = 0.3
		dolphinImageView = UIImageView(image: dolphinImage)
		dolphinImageView.center = view.center
		view.addSubview(overlay)
		view.addSubview(dolphinImageView)

	}
	
	func rotateView() {
		
		UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: { () -> Void in
			self.dolphinImageView.transform = self.dolphinImageView.transform.rotated(by: CGFloat(M_PI_2))
		}) { (finished) -> Void in
			if self.animated {self.rotateView()}
		}
	}
	
	func animate(){
		animated = true
		rotateView()
		superview.addSubview(view)
	}
	
	func stopAnimation(){
		animated = false
		view.removeFromSuperview()
	}
}
