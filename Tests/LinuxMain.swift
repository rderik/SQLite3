import XCTest

import SQLite3Tests

var tests = [XCTestCaseEntry]()
tests += SQLite3Tests.allTests()
XCTMain(tests)
