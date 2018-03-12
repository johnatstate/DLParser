import Foundation

/**
    A basic Field Parsing implementation that can be extended to support multiple AAMVA Versions
*/
public class FieldParser {

  /// Used to convert cm to inches for height calculations
  static let inchesPerCentimeter: Double = 0.393701

  /// A Regex object for doing the heavy lifting
  let regex: Regex = Regex()

  /// A Field Mapping object for finding fields in the raw data
  public var fieldMapper: FieldMapping

  /// The raw data from an AAMVA spec adhering PDF-417 barcode
  public var data: String

  /**
    Initializes a new Field Parser

    - Parameters:
      - data: The AAMVA spec adhering PDF-417 barcode data
      - fieldMapper: A FieldMapping object

    - Returns: An initialized Field Parser
  */
  public init(data: String, fieldMapper: FieldMapping){
    self.data = data
    self.fieldMapper = fieldMapper
  }

  /**
    Initializes a new Field Parser defaulting to the basic FieldMapper

    - Parameters:
      - data: The AAMVA spec adhering PDF-417 barcode data

    - Returns: An initialized Field Parser
  */
  public convenience init(data: String){
    self.init(data: data, fieldMapper: FieldMapper())
  }

  /**
    Parse a string out of the raw data

    - Parameters:
      - The human readable key we're looking for

    - Returns: An optional value parsed out of the raw data
  */

  public func parseString(key: String) -> String?{
    let identifier = fieldMapper.fieldFor(key: key)
    return regex.firstMatch(pattern: "\(identifier)(.+)\\b", data: data)
  }

  /**
    Parse a double out of the raw data.

    - Parameters:
      - The human readable key we're looking for

    - Returns: An optional value parsed out of the raw data
  */
  public func parseDouble(key: String) -> Double?{
    let identifier = fieldMapper.fieldFor(key: key)
    let result = regex.firstMatch(pattern: "\(identifier)(\\w+)\\b", data: data)
    guard let unwrappedResult = result else { return nil }

    return Double(unwrappedResult)
  }

  /**
    Parse a date out of the raw data

    - Parameters:
      - The human readable key we're looking for

    - Returns: An optional value parsed out of the raw data
  */
    public func parseDate(key field: String) -> NSDate?{
        guard let dateString = parseString(key: field) else { return nil }
    guard !dateString.isEmpty else { return nil }

        let formatter = DateFormatter()
    formatter.dateFormat = getDateFormat()
        guard let parsedDate = formatter.date(from: dateString) else { return nil }

        return parsedDate as NSDate
  }

  /**
    The string format used with an NSDateFormatter to parse dates. Usually 'yyyyMMdd' or 'MMddyyyy'.

    - Returns: An NSDateFormatter formatter string acceptable date format
  */
  public func getDateFormat() -> String {
    return "MMddyyyy"
  }

  /**
    Parse the AAMVA last name out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseFirstName() -> String?{
    return parseString(key: "firstName")
  }

  /**
    Parse the AAMVA last name out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseLastName() -> String?{
    return parseString(key: "lastName")
  }

  /**
    Parse the AAMVA middle name out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseMiddleName() -> String?{
    return parseString(key: "middleName")
  }

  /**
    Parse the AAMVA expiration date out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseExpirationDate() -> NSDate?{
    return parseDate(key: "expirationDate")
  }

  /**
    Parse the AAMVA issue date out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseIssueDate() -> NSDate?{
    return parseDate(key: "issueDate")
  }

  /**
    Parse the AAMVA date of birth out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseDateOfBirth() -> NSDate?{
    return parseDate(key: "dateOfBirth")
  }

  /**
    Parse the AAMVA issuing country out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseCountry() -> IssuingCountry {
    guard let country = parseString(key: "country") else { return .unknown }
    return IssuingCountry.of(country)
  }

  /**
    Parse the AAMVA name truncation statuses out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseTruncationStatus(field: String) -> Truncation {
    guard let truncation = parseString(key: field) else { return .unknown }
    return Truncation.of(truncation)
  }

  /**
    Parse the AAMVA gender out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseGender() -> Gender{
    guard let gender = parseString(key: "gender") else { return .unknown }
    return Gender.of(gender)
  }

  /**
    Parse the AAMVA eye color out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseEyeColor() -> EyeColor{
    guard let color = parseString(key: "eyeColor") else { return .unknown }
    return EyeColor.of(color)
  }

  /**
    Parse the AAMVA name suffix out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseNameSuffix() -> NameSuffix{
    guard let suffix = parseString(key: "suffix") else { return .unknown }
    return NameSuffix.of(suffix)
  }

  /**
    Parse the AAMVA hair color out of the raw data

    - Returns: An optional value parsed out of the raw data
  */
  public func parseHairColor() -> HairColor{
    guard let color = parseString(key: "hairColor") else { return .unknown }
    return HairColor.of(color)
  }

  /**
    Parse the AAMVA height out of the raw data

    - Returns: An optional value parsed out of the raw data in inches
  */
  public func parseHeight() -> Double?{
    guard let heightString = parseString(key: "height") else { return nil }
    guard let height = parseDouble(key: "height") else { return nil }

    if heightString.contains("cm"){
      return Double(round(height * FieldParser.inchesPerCentimeter))
    }else{
      return height
    }
  }

}
