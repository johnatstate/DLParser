//
//  VersionOneFieldParser.swift
//  Pods
//
//  Created by Clayton Lengel-Zigich on 6/10/16.
//
//

import Foundation

class VersionOneFieldParser: FieldParser {
    
    override init(data: String) {
        super.init(data: data)
        self.fields[FieldKeys.customerId] = "DBJ"
        self.fields[FieldKeys.lastName]   = "DAB"
        self.fields[FieldKeys.driverLicenseName] = "DAA"
    }

    override func getDateFormat() -> String {
        return "yyyyMMdd"
    }

    override func parseFirstName() -> String? {
        return parseString(key: FieldKeys.firstName)
            ?? parseDriverLicenseName(key: FieldKeys.firstName)
    }

    override func parseLastName() -> String? {
        return parseString(key: FieldKeys.lastName)
            ?? parseDriverLicenseName(key: FieldKeys.lastName)
    }

    override func parseMiddleName() -> String? {
        return parseString(key: FieldKeys.middleName)
            ?? parseDriverLicenseName(key: FieldKeys.middleName)
    }

    // Parse something like 508 (5'8") into 68"
    override func parseHeight() -> Double? {
        guard
        let rawHeight = parseString(key: FieldKeys.height),
        let heightString = regex.firstMatch(pattern: "([0-9]{1})", data: rawHeight),
        let inchesString = regex.firstMatch(pattern: "[0-9]{1}([0-9]{2})", data: rawHeight),
        let height = Double(heightString),
        let inches = Double(inchesString) else {
            return nil
        }

        let calculatedHeight = height * 12 + inches
        return rawHeight.contains("cm")
            ? round(calculatedHeight * FieldParser.inchesPerCentimeter)
            : calculatedHeight
    }

    override func parseNameSuffix() -> NameSuffix? {
        guard let suffix = parseString(key: FieldKeys.suffix)
            ?? parseDriverLicenseName(key: FieldKeys.suffix) else {
            return nil
        }
        return NameSuffix.of(suffix)
    }

    private func parseDriverLicenseName(key: String) -> String? {
        // Get the name components of the driver license
        guard let driverLicenseName = parseString(key: FieldKeys.driverLicenseName) else {
            return nil
        }
        let nameComponents = driverLicenseName.split{ $0 == "," }.map(String.init)

        // Return the name component associated with the key
        switch key {
        case FieldKeys.lastName:
            return nameComponents.first
        case FieldKeys.firstName where nameComponents.count > 2:
            return nameComponents[1]
        case FieldKeys.middleName where nameComponents.count > 3:
            return nameComponents[2]
        case FieldKeys.suffix where nameComponents.count > 4:
            return nameComponents[3]
        default:
            return nil
        }
    }
}
