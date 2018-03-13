import Foundation

/**
    Primary type used to parse driver license data.
 */
public final class Parser {

    /// The AAMVA PDF417 raw barcode data being used for parsing
    public let data: String

    /**
        Initializes a new Parser

        - Parameters:
            - data: The AAMVA PDF417 raw barcode data

        - Returns: A configured Parser ready to parse and generate a ParsedLicense
     */
    public init(data: String) {
        self.data = data
    }

    /**
        Parses the AAMVA PDF417 raw barcode data based on the specific AAMVA document version

        - Returns: A ParsedLicense with all available parsed fields
     */
    public func parse() -> License {
        let version = parseVersion()
        let fieldParser = versionBasedFieldParsing(version: version)
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
            streetAddress           : fieldParser.parseString(key: FieldKeys.streetAddress),
            city                    : fieldParser.parseString(key: FieldKeys.city),
            state                   : fieldParser.parseString(key: FieldKeys.state),
            postalCode              : fieldParser.parseString(key: FieldKeys.postalCode),
            customerId              : fieldParser.parseString(key: FieldKeys.customerId),
            documentId              : fieldParser.parseString(key: FieldKeys.documentId),
            country                 : fieldParser.parseCountry(),
            middleNameTruncation    : fieldParser.parseTruncationStatus(field: FieldKeys.middleNameTruncation),
            firstNameTruncation     : fieldParser.parseTruncationStatus(field: FieldKeys.firstNameTruncation),
            lastNameTruncation      : fieldParser.parseTruncationStatus(field: FieldKeys.lastNameTruncation),
            streetAddressSupplement : fieldParser.parseString(key: FieldKeys.streetAddressSupplement),
            hairColor               : fieldParser.parseHairColor(),
            placeOfBirth            : fieldParser.parseString(key: FieldKeys.placeOfBirth),
            auditInformation        : fieldParser.parseString(key: FieldKeys.auditInformation),
            inventoryControlNumber  : fieldParser.parseString(key: FieldKeys.inventoryControlNumber),
            lastNameAlias           : fieldParser.parseString(key: FieldKeys.lastNameAlias),
            firstNameAlias          : fieldParser.parseString(key: FieldKeys.firstNameAlias),
            suffixAlias             : fieldParser.parseString(key: FieldKeys.suffixAlias),
            suffix                  : fieldParser.parseNameSuffix(),
            version                 : parseVersion(),
            pdf417                  : data
        )
    }

    private func versionBasedFieldParsing(version: String?) -> FieldParser {
        let defaultParser = FieldParser(data: data)
        guard let version = version else {
            return defaultParser
        }

        switch version {
        case "01": return VersionOneFieldParser(data: data)
        case "02": return VersionTwoFieldParser(data: data)
        case "03": return VersionThreeFieldParser(data: data)
        case "04": return VersionFourFieldParser(data: data)
        case "05": return VersionFiveFieldParser(data: data)
        case "08": return VersionEightFieldParser(data: data)
        default:   return defaultParser
        }
    }

    private func parseVersion() -> String? {
        return Regex().firstMatch(pattern: "\\d{6}(\\d{2})\\w+",
                                data: data)
    }
}
