//
//  NetworkManager.swift
//  CoEpi
//
//  Created by Hamish Rodda on 27/3/20.
//  Copyright © 2020 org.coepi. All rights reserved.
//

import Foundation
import Alamofire

struct ExposureCheck: Codable {
    let lastChecked: Date
    //let geoHash: String
}

struct ExposureResponse: Codable {
  let cenKey: String
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
               encoder: JSONParameterEncoder.default).validate().responseDecodable
    {
      (response: DataResponse<ExposureResponse, AFError>) in
      
      switch response.result {
      case .success(let exposureResponse):
        print(exposureResponse)
        self.lastSuccessfulExposureCheck = self.currentAttemptedExposureCheck
        
      case .failure(let error):
          print(error.localizedDescription)
      }

    }
  }

}
