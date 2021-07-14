//
//  ViewController.swift
//  MyMotor
//
//  Created by Robert Hardy on 12/07/2021.
//

import UIKit
import Foundation

class Home_ViewController: UIViewController
{
    @IBOutlet weak var registrationTextField: UITextField!
    @IBOutlet weak var findCarButton: UIButton!
    @IBOutlet weak var vehicleInformationTextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        NotificationCenter.default.addObserver(self, selector: #selector(motDetailsRetrievedSuccess), name: Notification.Name("motDetailsRetrievedSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(motDetailsRetrievedError), name: Notification.Name("motDetailsRetrievedError"), object: nil)
    }
    
    @IBAction func findCarButtonPressed()
    {
        let registration_plate = registrationTextField.text!
        
        if registration_plate == "FG14UYN"
        {
            let alert_success = UIAlertController(title: "Error", message: "Detected that vehicle is in need of a deep clean.", preferredStyle: .alert)
            let default_action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert_success.addAction(default_action)
            self.present(alert_success, animated: true, completion: nil)
        }
        
        DVSA().get_vehicle_details(registration_plate: registration_plate)
    }
    
    @objc func motDetailsRetrievedSuccess()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let timestampVehicleMotExpiry = dateFormatter.date(from: DVSA.vehicleMotExpiry)
        let timestampVehicleRegistrationDate = dateFormatter.date(from: DVSA.vehicleRegistrationDate)

        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        newDateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        newDateFormatter.dateStyle = .long
        newDateFormatter.timeStyle = .none
        
        let friendlyVehicleMotExpiry = newDateFormatter.string(from: timestampVehicleMotExpiry!)
        let friendlyVehicleRegistrationDate = newDateFormatter.string(from: timestampVehicleRegistrationDate!)
        
        
        vehicleInformationTextView.text = "\(DVSA.vehicleMake.capitalized) \(DVSA.vehicleModel.capitalized) (\(DVSA.vehiclePrimaryColour))  \nRegistered on: \(friendlyVehicleRegistrationDate) \nMileage (at last MOT): \(DVSA.vehicleOdometerValue) \nMOT Expires: \(friendlyVehicleMotExpiry) \nMOT Count: \(DVSA.vehicleMotCount) \nAdvisories Count (previous MOT): \(DVSA.vehicleLatestMotAdvisoriesCount)"
    }
    @objc func motDetailsRetrievedError()
    {
        let alert_success = UIAlertController(title: "Error", message: "Unable to locate vehicle with specified registration plate.", preferredStyle: .alert)
        let default_action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert_success.addAction(default_action)
        self.present(alert_success, animated: true, completion: nil)
    }

}

