//
//  VersionOneFieldParser.swift
//  Pods
//
//  Created by Clayton Lengel-Zigich on 6/10/16.
//
//

import Foundation

/**
    Published 2000.
 */
class VersionOneParser: AAMVAParser {
    
    override init(data: String) {
        super.init(data: data)
        fields[FieldKey.jVehicleClass] = nil
        fields[FieldKey.jRestrictionCode] = nil
        fields[FieldKey.jEndorsementCode] = nil
        fields[FieldKey.lastName] = "DAB"
        fields[FieldKey.uniqueDocumentId] = "DBJ"
        fields[FieldKey.country] = nil  // TODO: No documentation?
        fields[FieldKey.lastNameTruncation] = nil
        fields[FieldKey.firstNameTruncation] = nil
        fields[FieldKey.middleNameTruncation] = nil
        fields[FieldKey.placeOfBirth] = nil
        fields[FieldKey.auditInformation] = nil
        fields[FieldKey.inventoryControlNumber] = nil
        fields[FieldKey.lastNameAlias] = "DBO"
        fields[FieldKey.givenNameAlias] = "DBP"
        fields[FieldKey.suffixAlias] = "DBR"
        fields[FieldKey.suffix] = "DAE"
        fields[FieldKey.weightRange] = nil
        fields[FieldKey.race] = nil
        fields[FieldKey.sVehicleCode] = "PAA"
        fields[FieldKey.sEndorsementCode] = "PAF"
        fields[FieldKey.sRestrictionCode] = "PAE"
        fields[FieldKey.jVehicleClassDescription] = nil
        fields[FieldKey.jEndorsementCodeDescription] = nil
        fields[FieldKey.jRestrictionCodeDescription] = nil
        fields[FieldKey.complianceType] = nil
        fields[FieldKey.revisionDate] = nil
        fields[FieldKey.hazmatExpirationDate] = nil
        fields[FieldKey.isTemporaryDocument] = nil
        fields[FieldKey.isOrganDonor] = "DBH"
        fields[FieldKey.isVeteran] = nil
    }
    
    override var unitedStatesDateFormat: String {
        return "yyyyMMdd"
    }

    override func parseFirstName() -> String? {                
        return parseString(key: FieldKey.firstName)
            ?? parseDriverLicenseName(key: FieldKey.firstName)
    }

    override func parseLastName() -> String? {
        return parseString(key: FieldKey.lastName)
            ?? parseDriverLicenseName(key: FieldKey.lastName)
    }

    override func parseMiddleName() -> String? {
        return parseString(key: FieldKey.middleName)
            ?? parseDriverLicenseName(key: FieldKey.middleName)
    }

    // Parse something like 508 (5'8") into 68"
    override func parseHeight() -> Double? {
        guard  // TODO: Height parsing for cm field
        let rawHeight = parseString(key: FieldKey.heightInches),
        let heightString = NSRegularExpression.firstMatch(pattern: "([0-9]{1})", data: rawHeight),
        let inchesString = NSRegularExpression.firstMatch(pattern: "[0-9]{1}([0-9]{2})", data: rawHeight),
        let height = Double(heightString),
        let inches = Double(inchesString) else {
            return nil
        }

        let calculatedHeight = height * 12 + inches
        return rawHeight.contains("cm")
            ? UnitConverter.inches(from: calculatedHeight)
            : calculatedHeight
    }

    override func parseNameSuffix() -> NameSuffix? {
        guard let suffix = parseString(key: FieldKey.suffix)
            ?? parseDriverLicenseName(key: FieldKey.suffix) else {
            return nil
        }
        return NameSuffix.of(suffix)
    }

    // TODO: This does not parse out the middle name correctly
    private func parseDriverLicenseName(key: FieldKey) -> String? {
        // Get the name components of the driver license
        guard let driverLicenseName = parseString(key: FieldKey.driverLicenseName) else {
            return nil
        }
        let nameComponents = driverLicenseName.split{ $0 == "," }.map(String.init)

        // Return the name component associated with the key
        switch key {
        case .lastName:
            return nameComponents.first
        case .firstName where nameComponents.count > 2:
            return nameComponents[1]
        case .middleName where nameComponents.count > 3:
            return nameComponents[2]
        case .suffix where nameComponents.count > 4:
            return nameComponents[3]
        default:
            return nil
        }
    }
}
