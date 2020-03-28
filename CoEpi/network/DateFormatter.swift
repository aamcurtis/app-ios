//
//  DateFormatter.swift
//  
//
//  Created by Hamish Rodda on 28/3/20.
//

import Foundation

extension DateFormatter {
    static var unixDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
