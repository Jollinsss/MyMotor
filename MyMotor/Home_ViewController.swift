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
        NotificationCenter.default.addObserver(self, selector: #selector(motDetailsRetrievedError), name: Notification.Name("taxDetailsRetrievedError"), object: nil)
    }
    
    @IBAction func findCarButtonPressed()
    {
        let registration_plate = registrationTextField.text!
        
        DVSA().get_tax_details(registration_plate: registration_plate)
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
        
        let friendlyVehicleMotExpiry = newDateFormatter.string(from: timestampVehicleMotExpiry ?? Date())
        let friendlyVehicleRegistrationDate = newDateFormatter.string(from: timestampVehicleRegistrationDate ?? Date())
        
        
        vehicleInformationTextView.text = "\(DVSA.vehicleMake.capitalized) \(DVSA.vehicleModel.capitalized) (\(DVSA.vehiclePrimaryColour))  \nRegistered on: \(friendlyVehicleRegistrationDate) \nMileage (at last MOT): \(DVSA.vehicleOdometerValue) \nMOT Expires: \(friendlyVehicleMotExpiry) \nMOT Count: \(DVSA.vehicleMotCount) \nAdvisories Count (previous MOT): \(DVSA.vehicleLatestMotAdvisoriesCount) \nVehicle is \(DVSA.vehicleIsTaxed) \nVehicle Tax Due Date: \(DVSA.vehicleTaxDueDate) \nCo2 Emissions: \(DVSA.vehicleCo2Emissions)"
        
        performSegue(withIdentifier: "goToVehicle", sender: self)
    }
    
    @objc func motDetailsRetrievedError()
    {
        let alert_success = UIAlertController(title: "Error", message: "Unable to locate vehicle with specified registration plate.", preferredStyle: .alert)
        let default_action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert_success.addAction(default_action)
        self.present(alert_success, animated: true, completion: nil)
    }

}

