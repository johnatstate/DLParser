import Foundation

/// A Representation of the scanned AAMVA License
public struct License {

  /// The license holder's first/given name
  public var firstName: String?

  /// The license holder's last/given name
  public var lastName: String?

  /// The license holder's middle name
  public var middleName: String?

  /// The expiration date of the license
  public var expirationDate: NSDate?

  /// The issue date of the license
  public var issueDate: NSDate?

  /// The license holder's date of birth
  public var dateOfBirth: NSDate?

  /// The license holder's gender
  public var gender: LicenseParser.Gender?

  /// The license holder's eye color
  public var eyeColor: LicenseParser.EyeColor?

  /// The license holder's height
  public var height: Double?

  /// The license holder's street address
  public var streetAddress: String?

  /// The license holder's city
  public var city: String?

  /// The license holder's state
  public var state: String?

  /// The license holder's postal code
  public var postalCode: String?

  /// The license holder's customer Id (e.g. Driver License Number)
  public var customerId: String?

  /// A unique document identifier
  public var documentId: String?

  /// The license's issuing country
  public var country: LicenseParser.IssuingCountry?

  /// A determination of if the middle name was truncated
  public var middleNameTruncation: LicenseParser.Truncation?

  /// A determination of if the first name was truncated
  public var firstNameTruncation: LicenseParser.Truncation?

  /// A determination of if the last name was truncated
  public var lastNameTruncation: LicenseParser.Truncation?

  /// The license holder's supplemental street address
  public var streetAddressSupplement: String?

  /// The license holder's hair color
  public var hairColor: LicenseParser.HairColor?

  /// The license holder's place of birth
  public var placeOfBirth: String?

  /// The license issuer's audit information
  public var auditInformation: String?

  /// The license issuer's
  public var inventoryControlNumber: String?

  /// The license holder's last name alias
  public var lastNameAlias: String?

  /// The license holder's first name alias
  public var firstNameAlias: String?

  /// The license holder's name suffix alias
  public var suffixAlias: String?

  /// The license holder's name suffix
  public var suffix: LicenseParser.NameSuffix?

  /// The AAMVA version to which this parsed license conforms
  public var version: String?

  /// The raw pdf417 scan data used to build this parsed license
  public var pdf417: String?

  /**
    Determines if the license is expired based on the `expirationDate`

    Returns: True when the current date is past the expiration date, false otherwise.
  */
  public func isExpired() -> Bool {
    guard let withDate = self.expirationDate else { return false }
    guard NSDate().compare(withDate as Date) == ComparisonResult.orderedDescending else { return false }
    return true
  }

  /**
    Determines if the license has been issued based on the `issueDate`

    Returns: True when the current date is past the issue date, false otherwise.
  */
  public func hasBeenIssued() -> Bool {
    guard let withDate = self.issueDate else { return false }
    guard NSDate().compare(withDate as Date) == ComparisonResult.orderedDescending else { return false }
    return true
  }

  /**
    Determines if enough of the license data is present to be useful for most things.

    Returns: True when a set of essential properties are non-empty, false otherwise.
  */

  public func isAcceptable() -> Bool{
    guard !isExpired() else { return false }
    guard hasBeenIssued() else { return false }

    guard expirationDate != nil else { return false }
    guard lastName       != nil else { return false }
    guard firstName      != nil else { return false }
    guard middleName     != nil else { return false }
    guard issueDate      != nil else { return false }
    guard dateOfBirth    != nil else { return false }
    guard height         != nil else { return false }
    guard streetAddress  != nil else { return false }
    guard city           != nil else { return false }
    guard state          != nil else { return false }
    guard postalCode     != nil else { return false }
    guard documentId     != nil else { return false }

    return true
  }
}
