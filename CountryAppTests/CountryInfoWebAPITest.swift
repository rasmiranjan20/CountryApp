//
//  CountryInfoWebAPITest.swift
//  CountryAppTests
//
//  Created by Rasmiranjan Sahu on 26/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import XCTest

class CountryInfoWebAPITest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testGetCountryInfo() {
        let expectation = self.expectation(description: "getCountryInfo")
        CountryInfoWebAPI .getCountryInfo { response in
            switch response {
                case .countryData(title: _, info: _):
                    XCTAssert(true)
                case .failedWithError(error: let error):
                    XCTAssertNotNil(error, "webservice error coming nil")
                case .failedWithMessage(message: let message):
                    XCTAssertNotNil(message, "webservice message coming nil")
            }
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 30)
    }
    
    func testParseCountryData() {
        let value = CountryInfoWebAPI .parseCountryData(data: Data())
        XCTAssertNotNil(value, "Parsing error")
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
