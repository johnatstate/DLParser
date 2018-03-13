import Foundation

/// A Representation of the scanned AAMVA License
public struct License {
    
    // MARK: - Properties

    /// The license holder's first/given name
    public var firstName: String?

    /// The license holder's last/given name
    public var lastName: String?

    /// The license holder's middle name
    public var middleName: String?

    /// The expiration date of the license
    public var expirationDate: Date?

    /// The issue date of the license
    public var issueDate: Date?

    /// The license holder's date of birth
    public var dateOfBirth: Date?

    /// The license holder's gender
    public var gender: Gender?

    /// The license holder's eye color
    public var eyeColor: EyeColor?

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
    public var country: IssuingCountry?

    /// A determination of if the middle name was truncated
    public var middleNameTruncation: Truncation?

    /// A determination of if the first name was truncated
    public var firstNameTruncation: Truncation?

    /// A determination of if the last name was truncated
    public var lastNameTruncation: Truncation?

    /// The license holder's supplemental street address
    public var streetAddressSupplement: String?

    /// The license holder's hair color
    public var hairColor: HairColor?

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
    public var suffix: NameSuffix?

    /// The AAMVA version to which this parsed license conforms
    public var version: String?

    /// The raw pdf417 scan data used to build this parsed license
    public var pdf417: String?
}


// MARK: - Conditional Properties

extension License {

    /**
        Determines if the license is expired based on the `expirationDate`

        Returns: True when the current date is past the expiration date, false otherwise.
     */
    public var isExpired: Bool {
        guard let expirationDate = expirationDate else {
            return false
        }
        return Date() > expirationDate
    }

    /**
        Determines if the license has been issued based on the `issueDate`

        Returns: True when the current date is past the issue date, false otherwise.
     */
    public var isIssued: Bool {
        guard let issueDate = issueDate else {
            return false
        }
        return Date() > issueDate
    }

    /**
        Determines if enough of the license data is present to be useful for most things.

        Returns: True when a set of essential properties are non-empty, false otherwise.
     */
    public var isAcceptable: Bool {
        return documentId != nil
    }
}
