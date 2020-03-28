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

struct CENReport: Encodable {
  let reportID: Int
  let report: String
  let cenKeys: [Contact]
}


class NetworkManager {
  var lastSuccessfulExposureCheck = Date()
  var currentAttemptedExposureCheck = Date()
  var reportIndex : Int = 1
  
  func getRecentExposures() -> Void {
  
    let newCheck = ExposureCheck(lastChecked: lastSuccessfulExposureCheck)//, geoHash: "")
    
    // Set the current attempted exposure check date/time
    currentAttemptedExposureCheck = Date.init()
    
    let unixDT = currentAttemptedExposureCheck.timeIntervalSince1970
  
    AF.request("https://coepi.wolk.com:8080/cenkeys/\(unixDT)",
               method: .get,
               parameters: newCheck,
               encoder: JSONParameterEncoder.default).validate().responseDecodable
    {
      (response: DataResponse<ExposureResponse, AFError>) in
      
      switch response.result {
      case .success(let exposureResponse):
        print(exposureResponse)
        // proximityEngine.checkExposures(exposureResponse)
        self.lastSuccessfulExposureCheck = self.currentAttemptedExposureCheck
        
      case .failure(let error):
          print(error.localizedDescription)
      }
    }
  }
  
  func sendSymptomReport(symptoms: String, proximityEvents: [Contact]) -> Void {
    let newReport = CENReport(reportID: reportIndex, report: symptoms, cenKeys: proximityEvents)
      
    AF.request("https://coepi.wolk.com:8080/cenreport",
               method: .post,
               parameters: newReport,
               encoder: JSONParameterEncoder.default).validate().response
    {
      response in
      
      switch response.result {
      case .success:
        print("Successful Symptom post")
        self.reportIndex += 1
        
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  func getSymptomReport() -> Void {
    
  }
}
