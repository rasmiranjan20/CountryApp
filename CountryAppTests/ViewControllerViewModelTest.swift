//
//  ViewControllerViewModelTest.swift
//  CountryAppTests
//
//  Created by Rasmiranjan Sahu on 26/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import XCTest

class ViewControllerViewModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testViewController() {
        var info1: CountryInformation = (nil, nil)
        var viewModel = ViewControllerViewModel(data: info1)
        XCTAssertNotNil(viewModel, "ViewControllerViewModel is nil")
        
        info1.title = "Rasmiranjan"
        viewModel = ViewControllerViewModel(data: info1)
        XCTAssertNotNil(viewModel, "ViewControllerViewModel is nil")
        
        info1.info = [CountryInfoModel()]
        viewModel = ViewControllerViewModel(data: info1)
        XCTAssertNotNil(viewModel, "ViewControllerViewModel is nil")
        
        XCTAssertGreaterThanOrEqual(viewModel.numberOfRow(), 0)
    }
    
    func testCountryTableCell() {
        let viewModel = CountryCellViewModel(load: CountryInfoModel())
        XCTAssertNotNil(viewModel.title(), "Country cell View model title coming nil")
        XCTAssertNotNil(viewModel.information(), "Country cell View model information coming nil")

        let expectation = self.expectation(description: "showThumbnail")
        _ = viewModel.showThumbnail { image in
            XCTAssert(true)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 120)
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
