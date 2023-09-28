//
//  QueryParamBuilderTests.swift
//  HowsItLookingTests
//
//  Created by Nick Jones on 28/09/2023.
//

import XCTest
@testable import HowsItLooking

final class QueryParamBuilderTests: XCTestCase {

    func testThat3QueryParamsAreSuccesfullyParsedToAString() throws {
        let queryParams: KeyValuePairs = ["foo": 1, "bar": 2, "fizz": "buzz"] as KeyValuePairs<String, Any>
        
        let queryParamsAsString = queryParams.queryParams()
        XCTAssertEqual(queryParamsAsString, "?foo=1&bar=2&fizz=buzz")
    }
    
    func testThat0QueryParamsAreSuccesfullyParsedToAnEmptyString() throws {
        let queryParams: KeyValuePairs = [:] as KeyValuePairs<String, Any>
        
        let queryParamsAsString = queryParams.queryParams()
        XCTAssertEqual(queryParamsAsString, "")
    }
}
