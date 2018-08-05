import XCTest

import osxTests

var tests = [XCTestCaseEntry]()
tests += osxTests.allTests()
XCTMain(tests)