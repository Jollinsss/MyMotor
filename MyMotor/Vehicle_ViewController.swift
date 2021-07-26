//
//  Vehicle_ViewController.swift
//  MyMotor
//
//  Created by Robert Hardy on 26/07/2021.
//

import UIKit

class Vehicle_ViewController: UIViewController
{
    @IBOutlet weak var vehicleMake: UILabel!
    @IBOutlet weak var vehicleModel: UILabel!
    @IBOutlet weak var vehicleRegistration: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dismissbutton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        vehicleMake.text = DVSA.vehicleMake.uppercased()
        vehicleModel.text = DVSA.vehicleModel.uppercased()
        vehicleRegistration.text = DVSA.vehicleRegistration.uppercased()
    }

    @IBAction func addVehicle()
    {
        let alert_success = UIAlertController(title: "Success", message: "Vehicle added to account.", preferredStyle: .alert)
        let default_action = UIAlertAction(title: "Dismiss", style: .default, handler: {
        _ in
            self.dismiss(animated: true, completion: nil)
        })
        alert_success.addAction(default_action)
        self.present(alert_success, animated: true, completion: nil)
    }
    
    @IBAction func dismiss()
    {
        dismiss(animated: true, completion: nil)
    }
    
}
