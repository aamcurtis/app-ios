//
//  NetworkManager.swift
//  CoEpi
//
//  Created by Hamish Rodda on 27/3/20.
//  Copyright © 2020 org.coepi. All rights reserved.
//

import Foundation
import Alamofire

struct ExposureCheck: Encodable {
    let lastChecked: Date
    //let geoHash: String
}

class NetworkManager {
  var lastSuccessfulExposureCheck = Date()
  var currentAttemptedExposureCheck = Date()
  
  func getRecentExposures() -> Void {
  
    let newCheck = ExposureCheck(lastChecked: lastSuccessfulExposureCheck)//, geoHash: "")
    
    // Set the current attempted exposure check date/time
    currentAttemptedExposureCheck = Date.init()
    
    AF.request("https://coepi.wolk.com:8080/cenkeys",
               method: .post,
               parameters: newCheck,
               encoder: JSONParameterEncoder.default).validate().responseJSON { response in
      debugPrint("Response: \(response)")
                
      self.lastSuccessfulExposureCheck = self.currentAttemptedExposureCheck
    }
  }

}
