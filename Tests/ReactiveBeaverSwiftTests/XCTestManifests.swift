import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ZipUnarchiverTests.allTests),
        testCase(ParserTests.allTests),
    ]
}
#endif
