//
//  Networking.swift
//  MyMotor
//
//  Created by Robert Hardy on 12/07/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class DVSA
{
    private let base_url = "https://beta.check-mot.service.gov.uk/trade/vehicles/"
    static var vehicleOdometerValue = 0
    static var vehicleMotCount = 0
    static var vehicleMotExpiry = ""
    static var vehicleLatestMotAdvisories: [advisories]?
    static var vehicleLatestMotAdvisoriesCount = 0
    static var vehicleMake = ""
    static var vehicleModel = ""
    static var vehiclePrimaryColour = ""
    static var vehicleRegistrationDate = ""
    static var vehicleIsTaxed = ""
    static var vehicleTaxDueDate = "01/01/1970"
    static var vehicleCo2Emissions = 0
    
    struct advisories
    {
        var type: String
        var text: String
    }
    
    func get_tax_details(registration_plate: String)
    {
        let url = "https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles"
        
        let headers: HTTPHeaders =
        [
            "x-api-key": "t5Sdb47fz87UaJvCczOmG6r4v3zlzZk47vj854oE",
            "content-type": "application/json",
        ]
        
        let bodyParameters: [String: Any] =
        [
            "registrationNumber": registration_plate
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: bodyParameters,
                    encoding: JSONEncoding.default,
                    headers: headers).responseJSON(completionHandler: {
                        response in

                        let statusCode: Int = response.response?.statusCode ?? 0
                        let json = JSON(response.data ?? "No JSON data")
                        
                        print("\(statusCode) - \(json)")
                        
                        if statusCode >= 200 && statusCode <= 299
                        {
                            DVSA.vehicleIsTaxed = json["taxStatus"].stringValue
                            DVSA.vehicleTaxDueDate = json["taxDueDate"].stringValue
                            DVSA.vehicleCo2Emissions = json["co2Emissions"].intValue
                            
                            DVSA().get_vehicle_details(registration_plate: registration_plate)
                        }
                        else
                        {
                            NotificationCenter.default.post(name: Notification.Name("taxDetailsRetrievedError"), object: nil)
                        }
                        
                    })
    }
    
    func get_vehicle_details(registration_plate: String)
    {
        let path = "mot-tests?registration=\(registration_plate)"
        
        let headers: HTTPHeaders =
        [
            "x-api-key": "",
            "content-type": "application/json",
        ]
        
        AF.request(base_url + path,
                    method: .get,
                    encoding: JSONEncoding.default,
                    headers: headers).responseJSON(completionHandler: {
                        response in

                        let statusCode: Int = response.response?.statusCode ?? 0
                        let json = JSON(response.data ?? "No JSON data")
                        
                        print("\(statusCode) - \(json)")
                        
                        if statusCode >= 200 && statusCode <= 299
                        {
                            DVSA.vehicleOdometerValue = json[0]["motTests"][0]["odometerValue"].intValue
                            DVSA.vehicleMotCount = json[0]["motTests"].arrayValue.count
                            DVSA.vehicleMotExpiry = json[0]["motTests"][0]["expiryDate"].stringValue
                            DVSA.vehicleMake = json[0]["make"].stringValue
                            DVSA.vehicleModel = json[0]["model"].stringValue
                            DVSA.vehiclePrimaryColour = json[0]["primaryColour"].stringValue
                            DVSA.vehicleRegistrationDate = json[0]["firstUsedDate"].stringValue
                            
                            let advisories = json[0]["motTests"][0]["rfrAndComments"].arrayValue
                            DVSA.vehicleLatestMotAdvisoriesCount = advisories.count
                            
                            NotificationCenter.default.post(name: Notification.Name("motDetailsRetrievedSuccess"), object: nil)
                        }
                        else
                        {
                            NotificationCenter.default.post(name: Notification.Name("motDetailsRetrievedError"), object: nil)
                        }
                        
                    })
    }
}
