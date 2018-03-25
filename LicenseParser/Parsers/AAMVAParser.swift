import Foundation

/**
    An abstract factory and base class for parsing driver license data
    that is AAMVA compliant. The class is responsible for parsing data
    on the detected version number.
    A basic Field Parsing implementation that can be extended to support multiple AAMVA Versions
*/
public class AAMVAParser {
    
    // MARK: - Properties

    /**
        The base fields common to all or most version standards. This
        field should be modified in subclasses for version-specific
        field changes.
     */
    public final var fields: [FieldKey: String] = [
        FieldKey.jVehicleClass:                 "DCA",
        FieldKey.jRestrictionCode:              "DCB",
        FieldKey.jEndorsementCode:              "DCD",
        FieldKey.expirationDate:                "DBA",
        FieldKey.issueDate:                     "DBD",
        FieldKey.firstName:                     "DAC",
        FieldKey.middleName:                    "DAD",
        FieldKey.lastName:                      "DCS",
        FieldKey.birthDate:                     "DBB",
        FieldKey.gender:                        "DBC",
        FieldKey.eyeColor:                      "DAY",
        FieldKey.heightInches:                  "DAU",
        FieldKey.streetAddress:                 "DAG",
        FieldKey.city:                          "DAI",
        FieldKey.state:                         "DAJ",
        FieldKey.postalCode:                    "DAK",
        FieldKey.driverLicenseNumber:           "DAQ",
        FieldKey.uniqueDocumentId:              "DCF",
        FieldKey.country:                       "DCG",
        FieldKey.lastNameTruncation:            "DDE",
        FieldKey.firstNameTruncation:           "DDF",
        FieldKey.middleNameTruncation:          "DDG",
        FieldKey.streetAddressTwo:              "DAH",
        FieldKey.hairColor:                     "DAZ",
        FieldKey.placeOfBirth:                  "DCI",
        FieldKey.auditInformation:              "DCJ",
        FieldKey.inventoryControlNumber:        "DCK",
        FieldKey.lastNameAlias:                 "DBN",
        FieldKey.givenNameAlias:                "DBG",
        FieldKey.suffix:                        "DBS", // TODO: Or DCU
        FieldKey.weightRange:                   "DCE",
        FieldKey.race:                          "DCL",
        FieldKey.sVehicleCode:                  "DCM",
        FieldKey.sEndorsementCode:              "DCN",
        FieldKey.sRestrictionCode:              "DCO",
        FieldKey.jVehicleClassDescription:      "DCP",
        FieldKey.jEndorsementCodeDescription:   "DCQ",
        FieldKey.jRestrictionCodeDescription:   "DCR",
        FieldKey.complianceType:                "DDA",
        FieldKey.revisionDate:                  "DDB",
        FieldKey.hazmatExpirationDate:          "DDC",
        FieldKey.weightPounds:                  "DAW",
        FieldKey.weightKilograms:               "DAX",
        FieldKey.isTemporaryDocument:           "DDD",
        FieldKey.isOrganDonor:                  "DDK",
        FieldKey.isVeteran:                     "DDL",
        FieldKey.fVehicleCode:                  "DCH",
        FieldKey.driverLicenseName:             "DAA",
        FieldKey.givenName:                     "DCT",
    ]

    /**
        The raw data from an AAMVA spec adhering PDF-417 barcode
     */
    public final let data: String
    
    /**
        The version number detected in the driver license data or nil
        if the data is not AAMVA compliant.
     */
    public var versionNumber: Int? {
        let pattern = "\\d{6}(\\d{2})\\w+"
        guard let match = NSRegularExpression.firstMatch(pattern: pattern,
                                                         data: data) as NSString? else {
            return nil
        }
        return match.integerValue
    }
    
    /**
        The number of subfiles found in the driver license data.
     */
    public var subfileCount: Int {
        let match = NSRegularExpression.firstMatch(pattern: "\\d{8}(\\d{2})\\w+",
                                                   data: data) as NSString?
        return match?.integerValue ?? 0
    }
    
    public var unitedStatesDateFormat: String {
        return "MMddyyyy"
    }
    
    public var canadaDateFormat: String {
        return "yyyyMMdd"
    }
    
    private var fieldParser: AAMVAParser {
        let defaultParser = AAMVAParser(data: data)
        guard let version = versionNumber else {
            return defaultParser
        }
        
        switch version {
        case 1:  return VersionOneParser(data: data)
        case 2:  return VersionTwoFieldParser(data: data)
        case 3:  return VersionThreeFieldParser(data: data)
        case 4:  return VersionFourFieldParser(data: data)
        case 5:  return VersionFiveFieldParser(data: data)
        case 8:  return VersionEightFieldParser(data: data)
        case 9:  return VersionNineParser(data: data)
        default: return defaultParser
        }
    }

    
    // MARK: - Object Lifecycle
    
    /**
        Initializes a new a driver license parser with the given license
        data.
     */
    public init(data: String) {
        self.data = data
    }
    
    
    // MARK: - Public Methods
    
    /**
        Parses the AAMVA PDF417 raw barcode data based on the specific AAMVA document version
     
        - Returns: A ParsedLicense with all available parsed fields
     */
    public func parse() -> License {
        let version = versionNumber
        let fieldParser = self.fieldParser
        return License(
            firstName               : fieldParser.parseFirstName(),
            lastName                : fieldParser.parseLastName(),
            middleName              : fieldParser.parseMiddleName(),
            expirationDate          : fieldParser.parseExpirationDate(),
            issueDate               : fieldParser.parseIssueDate(),
            dateOfBirth             : fieldParser.parseDateOfBirth(),
            gender                  : fieldParser.parseGender(),
            eyeColor                : fieldParser.parseEyeColor(),
            height                  : fieldParser.parseHeight(),
            streetAddress           : fieldParser.parseString(key: FieldKey.streetAddress),
            city                    : fieldParser.parseString(key: FieldKey.city),
            state                   : fieldParser.parseString(key: FieldKey.state),
            postalCode              : fieldParser.parseString(key: FieldKey.postalCode),
            customerId              : fieldParser.parseString(key: FieldKey.driverLicenseNumber),
            documentId              : fieldParser.parseString(key: FieldKey.uniqueDocumentId),
            country                 : fieldParser.parseCountry(),
            middleNameTruncation    : fieldParser.parseTruncationStatus(field: FieldKey.middleNameTruncation),
            firstNameTruncation     : fieldParser.parseTruncationStatus(field: FieldKey.firstNameTruncation),
            lastNameTruncation      : fieldParser.parseTruncationStatus(field: FieldKey.lastNameTruncation),
            streetAddressSupplement : fieldParser.parseString(key: FieldKey.streetAddressTwo),
            hairColor               : fieldParser.parseHairColor(),
            placeOfBirth            : fieldParser.parseString(key: FieldKey.placeOfBirth),
            auditInformation        : fieldParser.parseString(key: FieldKey.auditInformation),
            inventoryControlNumber  : fieldParser.parseString(key: FieldKey.inventoryControlNumber),
            lastNameAlias           : fieldParser.parseString(key: FieldKey.lastNameAlias),
            firstNameAlias          : fieldParser.parseString(key: FieldKey.firstNameAlias),
            suffixAlias             : fieldParser.parseString(key: FieldKey.suffixAlias),
            suffix                  : fieldParser.parseNameSuffix(),
            version                 : version,
            pdf417                  : data
        )
    }

    
    // MARK: - Generic Parsing

    func parseString(key: FieldKey) -> String? {
        guard let identifier = fields[key] else {
            return nil
        }
        return NSRegularExpression.firstMatch(pattern: "\(identifier)(.+)\\b", data: data)
    }
    
    func parseDouble(key: FieldKey) -> Double? {
        guard
        let identifier = fields[key],
        let result = NSRegularExpression.firstMatch(pattern:
            "\(identifier)(\\w+)\\b", data: data) else {
            return nil
        }
        return Double(result)
    }
    
    func parseDate(key: FieldKey) -> Date? {
        guard let dateString = parseString(key: key),
            !dateString.isEmpty else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.dateFormat = unitedStatesDateFormat  // TODO: Account CA
        return formatter.date(from: dateString)
    }
    
    
    // MARK: - Field Parsing
    
    func parseFirstName() -> String? {
        return parseString(key: FieldKey.firstName)
    }
    
    func parseLastName() -> String? {
        return parseString(key: FieldKey.lastName)
    }

    func parseMiddleName() -> String? {
        return parseString(key: FieldKey.middleName)
    }
    
    func parseExpirationDate() -> Date? {
        return parseDate(key: FieldKey.expirationDate)
    }
    
    func parseIssueDate() -> Date? {
        return parseDate(key: FieldKey.issueDate)
    }

    func parseDateOfBirth() -> Date? {
        return parseDate(key: FieldKey.birthDate)
    }

    func parseCountry() -> IssuingCountry? {
        guard let country = parseString(key: FieldKey.country) else {
            return nil
        }
        return IssuingCountry.of(country)
    }
    
    func parseTruncationStatus(field: FieldKey) -> Truncation? {
        guard let truncation = parseString(key: field) else {
            return nil
        }
        return Truncation.of(truncation)
    }
    
    func parseGender() -> Gender? {
        guard let gender = parseString(key: FieldKey.gender) else {
            return nil
        }
        return Gender.of(gender)
    }
    
    func parseEyeColor() -> EyeColor? {
        guard let color = parseString(key: FieldKey.eyeColor) else {
            return nil
        }
        return EyeColor.of(color)
    }
    
    func parseNameSuffix() -> NameSuffix? {
        guard let suffix = parseString(key: FieldKey.suffix) else {
            return nil
        }
        return NameSuffix.of(suffix)
    }

    func parseHairColor() -> HairColor? {
        guard let color = parseString(key: FieldKey.hairColor) else {
            return nil
        }
        return HairColor.of(color)
    }
    
    /// Returns height in inches
    func parseHeight() -> Double? {
        // TODO: Account height formats
        guard
        let heightString = parseString(key: FieldKey.heightInches),
        let height = parseDouble(key: FieldKey.heightInches) else {
            return nil
        }
        return heightString.contains("cm")
            ? UnitConverter.inches(from: height) : height
    }
}
