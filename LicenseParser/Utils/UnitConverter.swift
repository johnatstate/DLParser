//
//  UnitConverter.swift
//  LicenseParser
//
//  Created by Andrew Johnson on 3/13/18.
//

import Foundation

struct UnitConverter {
    
    static let inchesPerCentimeter: Double = 0.393701
    
    static func inches(from centimeters: Double) -> Double {
        let rawValue = round(centimeters
            * UnitConverter.inchesPerCentimeter)
        return Double(rawValue)
    }
}
