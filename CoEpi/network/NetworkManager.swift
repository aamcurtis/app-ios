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
    let geoHash: String
}

class NetworkManager {
  var lastSuccessfulExposureCheck = Date()
  
  func getRecentExposures() -> Void {
  
    let newCheck = ExposureCheck(lastChecked: lastSuccessfulExposureCheck, geoHash: "")
    
    AF.request("https://coepi.wolk.com:8080/exposureandsymptoms",
               method: .post,
               parameters: newCheck,
               encoder: JSONParameterEncoder.default).response { response in
      debugPrint(response)
    }
  }

}
