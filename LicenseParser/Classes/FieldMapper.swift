import Foundation

/// Defines Field Mapping Behavior
public protocol FieldMapping{
  /// A list of AAMVA field designator mappings (e.g. "firstName" => "DAC")
  var fields: [String: String] { get set }

  /**
    Determine the AAMVA field designator for a particular human readable key.

    - Parameters:
      - key: The human readable key

    - Returns: The AAMVA field designator
  */
  func fieldFor(key: String) -> String
}

/// A basic Field Mapping implementation based on the AAMVA Version 8 standard
public class FieldMapper: FieldMapping{

  /// A list of AAMVA field designator mappings (e.g. "firstName" => "DAC")
  public var fields: [String: String] = [
    FieldKeys.firstName               : "DAC",
    FieldKeys.lastName                : "DCS",
    FieldKeys.middleName              : "DAD",
    FieldKeys.expirationDate          : "DBA",
    FieldKeys.issueDate               : "DBD",
    FieldKeys.dateOfBirth             : "DBB",
    FieldKeys.gender                  : "DBC",
    FieldKeys.eyeColor                : "DAY",
    FieldKeys.height                  : "DAU",
    FieldKeys.streetAddress           : "DAG",
    FieldKeys.city                    : "DAI",
    FieldKeys.state                   : "DAJ",
    FieldKeys.postalCode              : "DAK",
    FieldKeys.customerId              : "DAQ",
    FieldKeys.documentId              : "DCF",
    FieldKeys.country                 : "DCG",
    FieldKeys.middleNameTruncation    : "DDG",
    FieldKeys.firstNameTruncation     : "DDF",
    FieldKeys.lastNameTruncation      : "DDE",
    FieldKeys.streetAddressSupplement : "DAH",
    FieldKeys.hairColor               : "DAZ",
    FieldKeys.placeOfBirth            : "DCI",
    FieldKeys.auditInformation        : "DCJ",
    FieldKeys.inventoryControlNumber  : "DCK",
    FieldKeys.lastNameAlias           : "DBN",
    FieldKeys.firstNameAlias          : "DBG",
    FieldKeys.suffixAlias             : "DBS",
    FieldKeys.suffix                  : "DCU"
  ]

  /**
    Determine the AAMVA field designator for a particular human readable key.

    - Parameters:
      - key: The human readable key

    - Returns: The AAMVA field designator
  */
  public func fieldFor(key: String) -> String {
    guard fields.keys.contains(key) else { return "" }

    return fields[key]!
  }
}
