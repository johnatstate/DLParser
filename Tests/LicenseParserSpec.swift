import Quick
import Nimble
@testable import LicenseParser

class LicenseParserSpec: QuickSpec {
  override func spec() {
    describe("Parsing Versions of the AAMVA DL/ID Card Design Standard"){
      describe("Parsed License"){
        it("should expose the raw pdf417 data"){
          let rawData = "@\n" +
            "\n" +
            "ANSI 636026010102DL00410288ZA03290015DLDBJD12345678\n" +
            "DAAPUBLIC,JOHN,Q\n" +
            "DABPUBLIC\n" +
            "DACJOHN\n" +
            "DADQUINCY\n" +
            "DAG789 E OAK ST\n" +
            "DAIANYTOWN\n" +
            "DAHAPT #4A\n" +
            "DAJCA\n" +
            "DAK90223\n" +
            "DBB19700115\n" +
            "DBA20350131\n" +
            "DAU509\n" +
            "DAW180\n" +
            "DAZBR\n" +
            "DAYGRN\n" +
            "DBC1\n" +
            "DBHN\n" +
            "DARD\n" +
            "DBD20131003\n" +
            "DBE2013-10-03 00.00.00.000000\n" +
            "DBIN\n" +
          "ZAZAA7V81\n"

          let sut = AAMVAParser(data: rawData)
          let result = sut.parse()
          expect(result.pdf417Data).to(equal(rawData))
        }
      }
    }
  }
}
