//
//  FilterViewController.swift
//  OnCall Trucker
//
//  Created by Stiven Deleur on 11/19/16.
//  Copyright © 2016 Stiven Deleur. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

	@IBOutlet weak var timeFromPicker: UIDatePicker!
	@IBOutlet weak var timeToPicker: UIDatePicker!
	@IBOutlet weak var distancePicker: UIPickerView!
	@IBOutlet weak var compensationPicker: UIPickerView!
	@IBOutlet weak var portPicker: UIPickerView!
	var currentFilter = JobFilter(timeFrom: Date(), timeTo: Date(), distance: 0, compensation: 0, port: 0)
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		distancePicker.dataSource = self;
		compensationPicker.dataSource = self;
		portPicker.dataSource = self;
		distancePicker.delegate = self;
		compensationPicker.delegate = self;
		portPicker.delegate = self;
		
		timeFromPicker.date = currentFilter.timeFrom
		timeToPicker.date = currentFilter.timeTo
		distancePicker.selectRow(currentFilter.distance, inComponent: 0, animated: false)
		compensationPicker.selectRow(currentFilter.compensation, inComponent: 0, animated: false)
		portPicker.selectRow(currentFilter.port, inComponent: 0, animated: false)
		
		
		// print("DATE: \(timeToPicker.date)")
        // Do any additional setup after loading the view.
    }
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int{
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		if pickerView.isEqual(distancePicker){
			return 6
		}else if pickerView.isEqual(compensationPicker){
			return 6
		}else if pickerView.isEqual(portPicker){
			return 2
		}else{
			return 0
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
		if pickerView.isEqual(distancePicker){
			return JobFilter.distancesStrings[row]
		}else if pickerView.isEqual(compensationPicker){
			return JobFilter.compensationsStrings[row]
		}else if pickerView.isEqual(portPicker){
			return JobFilter.portsStrings[row]
		}else{
			return ""
		}
	}
	@IBAction func applyFilter(_ sender: UIButton) {
		currentFilter.timeFrom = timeFromPicker.date
		currentFilter.timeTo = timeToPicker.date
		currentFilter.distance = distancePicker.selectedRow(inComponent: 0)
		currentFilter.compensation = compensationPicker.selectedRow(inComponent: 0)
		currentFilter.port = portPicker.selectedRow(inComponent: 0)
	
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
