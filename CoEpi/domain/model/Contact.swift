import Foundation
import CryptoKit

struct Contact : Codable {
    let cen: String
    let date: Date
  
  func createCenKey() -> String {
    
    let dateString = date.timeIntervalSince1970.description
    
    let mash = "\(cen)\(dateString)"
    let mashData = mash.data(using: .utf8)!
    
    let hash = SHA256.hash(data: mashData).description
    return hash
  }
}
