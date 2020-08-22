//
//  WeatherServiceTests.swift
//  SurfingSpotsTests
//
//  Created by Andrea Cerra on 8/22/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import XCTest

@testable import SurfingSpots

class WeatherServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testParsingValid() throws {
        
        // setup
        continueAfterFailure = false
        let expectation = XCTestExpectation(description: "Weather value downloaded")
        
        let httpService = HTTPServiceMock()
        httpService.jsonType = JSONType.WeatherResponse
        
        let weatherService = WeatherService(httpService: httpService)

        let remoteDataPublisher = weatherService.getWeatherForCity(city: "Rome")
            .sink(receiveCompletion: { completion in
                
                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished: expectation.fulfill()
                case .failure: XCTFail()
                }
                
            }, receiveValue: { weather in
                
                print(".sink() weather parsed \(weather)")
                
                guard (weather as Any) is WeatherData else {
                    XCTFail("Wrong data format")
                    return
                }
            })
        
        XCTAssertNotNil(remoteDataPublisher)
        wait(for: [expectation], timeout: 5.0)
    }

    func testWrongParsing() throws {
        
        // setup
        continueAfterFailure = false
        let expectation = XCTestExpectation(description: "Weather wrong parsing")
        
        let httpService = HTTPServiceMock()
        httpService.jsonType = .JSONError
        
        let weatherService = WeatherService(httpService: httpService)
        
        let remoteDataPublisher = weatherService.getWeatherForCity(city: "Rome")
            .sink(receiveCompletion: { completion in
                
                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished: XCTFail()
                case .failure(let error):
                    if case WeatherServiceError.ParsingDataError = error {
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
        let expectation = XCTestExpectation(description: "Weather value downloaded")

        let httpService = HTTPServiceMock()
        httpService.validHTTPConnection = false
        
        let weatherService = WeatherService(httpService: httpService)
        
        let remoteDataPublisher = weatherService.getWeatherForCity(city: "Rome")
            .sink(receiveCompletion: { completion in
                
                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished: XCTFail()
                case .failure(let error):
                    if case WeatherServiceError.WeatherNotAvailable = error {
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
