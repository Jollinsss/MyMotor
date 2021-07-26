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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        vehicleMake.text = DVSA.vehicleMake.uppercased()
        vehicleModel.text = DVSA.vehicleModel.uppercased()
    }

}
