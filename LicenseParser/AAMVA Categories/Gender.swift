//
//  Gender.swift
//  LicenseParser
//
//  Created by Andrew Johnson on 3/12/18.
//

import Foundation

/**
     AAMVA Genders
 
     - Male: Male
     - Female: Female
     - Other: Not yet part of the AAMVA spec
     - Unknown: When the gender cannot be determined
 */
public enum Gender: String {
    case male
    case female
    case other
    case unknown
}


// MARK: - Parsing

extension Gender {
    
    static func of(_ rawValue: String) -> Gender {
        switch rawValue {
        case "1":
            return .male
        case "2":
            return .female
        default:
            return .other
        }
    }
}
