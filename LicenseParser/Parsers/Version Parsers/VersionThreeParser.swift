//
//  VersionThreeParser.swift
//  Pods
//
//  Created by Clayton Lengel-Zigich on 7/11/16.
//
//

import Foundation

/**
    Published 03-2005.
 */
class VersionThreeFieldParser: AAMVAParser {
    
    override init(data: String) {
        super.init(data: data)
        fields[FieldKey.firstName] = nil
        fields[FieldKey.middleName] = nil
        fields[FieldKey.lastNameTruncation] = nil
        fields[FieldKey.firstNameTruncation] = nil
        fields[FieldKey.middleNameTruncation] = nil
        fields[FieldKey.complianceType] = nil
        fields[FieldKey.revisionDate] = nil
        fields[FieldKey.hazmatExpirationDate] = nil
        fields[FieldKey.weightPounds] = nil
        fields[FieldKey.weightKilograms] = nil
        fields[FieldKey.isTemporaryDocument] = nil
        fields[FieldKey.isOrganDonor] = nil
        fields[FieldKey.isVeteran] = nil
        fields[FieldKey.driverLicenseName] = nil
    }
    
    override func parseFirstName() -> String? {
        guard
        let givenName = parseString(key: FieldKey.givenName),
        let firstName = givenName.split(separator: ",").first else {
            return nil
        }
        return String(firstName)
    }
    
    override func parseMiddleName() -> String? {
        guard let givenName = parseString(key: FieldKey.givenName) else {
            return nil
        }
        let parts = givenName.split(separator: ",").dropFirst()
        return parts.joined(separator: " ")
    }
}
