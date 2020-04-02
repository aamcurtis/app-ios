//
//  NetworkManager.swift
//  CoEpi
//
//  Created by Hamish Rodda on 27/3/20.
//  Copyright © 2020 org.coepi. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire

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
  
  func getRecentExposures() -> String{
    let newCheck = ExposureCheck(lastChecked: lastSuccessfulExposureCheck)//, geoHash: "") // Not sure what this is meant to do, but it was included as a "parameters" to the alamofire implementation before testing of RxAlamofire
    // Set the current attempted exposure check date/time
    currentAttemptedExposureCheck = Date.init()
    let unixDT = Int(currentAttemptedExposureCheck.timeIntervalSince1970)
    let session = URLSession.shared
    
    var responseString = ""
    
    let response = session.rx
    .json(.get, "https://coepi.wolk.com:8080/cenkeys/\(unixDT)")
    .subscribe { print($0) }

    switch response {
    default:
        responseString = "Success"
    }
    
    return (responseString)
    
  }
  
  func sendSymptomReport(symptoms: String, proximityEvents: [Contact]) -> String {
    let newReport = CENReport(reportID: reportIndex, report: symptoms, cenKeys: proximityEvents) // Not sure what this is meant to do, but it was included as a "parameters" to the alamofire implementation before testing of RxAlamofire
    
    var responseString = ""
    
    var request = URLRequest(url: URL(string: "https://coepi.wolk.com:8080/cenreport")!)
    request.httpMethod = "POST"
    let response = RxAlamofire.request(request as URLRequestConvertible).responseJSON().asObservable()
    

      switch response {
      default:
          responseString = "Success"
      }
      
      return (responseString)
  }

  func getSymptomReport() -> Void {
    
  }
}
