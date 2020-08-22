//
//  CityServiceTests.swift
//  SurfingSpotsTests
//
//  Created by Andrea Cerra on 8/21/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import XCTest

@testable import SurfingSpots

class CityServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIntegrationRetrieveCities() throws {
        
        // setup
        continueAfterFailure = false
        let expectation = XCTestExpectation(description: "Cities downloaded")
        
        let httpService = HTTPService()
        let cityService = CityService(httpService: httpService)
        
        let remoteDataPublisher = cityService.getCities()
            .sink(receiveCompletion: { completion in
                
                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished: expectation.fulfill()
                case .failure: XCTFail()
                }
                
            }, receiveValue: { cities in
                
                print(".sink() cities parsed \(cities.count)")

                XCTAssertNotNil(cities)
                
                guard (cities as Any) is [City] else {
                    XCTFail("Wrong data format cities")
                    return
                }
            })
        
        XCTAssertNotNil(remoteDataPublisher)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testParsingValidJson() throws {
        
        // setup
        continueAfterFailure = false
        let expectation = XCTestExpectation(description: "Cities downloaded")
        
        let httpService = HTTPServiceMock()
        httpService.jsonType = JSONType.CitiesJson
        
        let cityService = CityService(httpService: httpService)
        
        let remoteDataPublisher = cityService.getCities()
            .sink(receiveCompletion: { completion in
                
                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished: expectation.fulfill()
                case .failure: XCTFail()
                }
                
            }, receiveValue: { cities in
                
                print(".sink() cities parsed \(cities.count)")
                
                XCTAssertNotNil(cities)
                
                guard (cities as Any) is [City] else {
                    XCTFail("Wrong data format cities")
                    return
                }
            })
        
        XCTAssertNotNil(remoteDataPublisher)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testParsingWrongJson() throws {
        
        // setup
        continueAfterFailure = false
        let expectation = XCTestExpectation(description: "Cities downloaded")
        
        let httpService = HTTPServiceMock()
        httpService.jsonType = JSONType.JSONError
        
        let cityService = CityService(httpService: httpService)
        
        let remoteDataPublisher = cityService.getCities()
            .sink(receiveCompletion: { completion in
                
                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished: XCTFail()
                case .failure(let error):
                    if case CityServiceError.InvalidJsonData = error {
                        expectation.fulfill()
                    }else{
                        XCTFail()
                    }
                }
                
            }, receiveValue: { _ in })
        
        XCTAssertNotNil(remoteDataPublisher)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testHTTPConnectionDown() throws {
        
        // setup
        continueAfterFailure = false
        let expectation = XCTestExpectation(description: "Cities downloaded")
        
        let httpService = HTTPServiceMock()
        httpService.validHTTPConnection = false
        
        let cityService = CityService(httpService: httpService)
        
        let remoteDataPublisher = cityService.getCities()
            .sink(receiveCompletion: { completion in
                
                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished: XCTFail()
                case .failure(let error):
                    if case CityServiceError.CannotRetrieveCities = error {
                        expectation.fulfill()
                    }else{
                        XCTFail()
                    }
                }
                
            }, receiveValue: { _ in })
        
        XCTAssertNotNil(remoteDataPublisher)
        wait(for: [expectation], timeout: 5.0)
    }
}
