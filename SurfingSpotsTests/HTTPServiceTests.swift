//
//  HTTPServiceTests.swift
//  SurfingSpotsTests
//
//  Created by Andrea Cerra on 8/20/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import XCTest

@testable import SurfingSpots

class HTTPServiceTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHTTPRequestSuccess() throws {
        
        // setup
        continueAfterFailure = false
        let endpoint = "https://run.mocky.io/v3/652ceb94-b24e-432b-b6c5-8a54bc1226b6"
        let expectation = XCTestExpectation(description: "Download json from \(endpoint)")
        
        let httpService = HTTPService()
        
        let remoteDataPublisher = httpService.makeHttpRequest(endpoint: endpoint)
            .sink(receiveCompletion: { completion in
                                
                switch completion {
                case .finished: expectation.fulfill()
                case .failure: XCTFail()
                }
                
            }, receiveValue: { httpRespose in
                
                let resultData = """
                {
                "cities": [{"name": "Cuba"}, {"name": "Los Angeles"}, {"name": "Miami"}, {"name": "Porto"}, {"name": "Ortona"}, {"name": "Riccione"}, {"name": "Midgar"}]
                }
                """.data(using: .utf8)
                
                XCTAssertNotNil(httpRespose.data)
                XCTAssertNotNil(httpRespose)
                XCTAssert(httpRespose.data == resultData)
            })
        
        XCTAssertNotNil(remoteDataPublisher)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testHTTPRequestEndpointNotValid() throws {
        
        // setup
        continueAfterFailure = false
        let endpoint = "wwwredditcomrspacextop.json"
        let expectation = XCTestExpectation(description: "Download json from \(endpoint)")
        
        let httpService = HTTPService()
        
        let remoteDataPublisher = httpService.makeHttpRequest(endpoint: endpoint)
            .sink(receiveCompletion: { completion in

                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished: XCTFail()
                case .failure(let error):
                    if case HTTPServiceError.HTTPRequestError(reason: _ ) = error {
                        expectation.fulfill()
                    }else{
                        XCTFail()
                    }
                }
                
            }, receiveValue: { _ in })
        
        XCTAssertNotNil(remoteDataPublisher)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testHTTPRequestError() throws {
        
        // setup
        continueAfterFailure = false
        let endpoint = "https:>>www.reddit.com/r/spacex/top.json"
        let expectation = XCTestExpectation(description: "Download json from \(endpoint)")
        let httpService = HTTPService()
        
        let remoteDataPublisher = httpService.makeHttpRequest(endpoint: endpoint)
            .sink(receiveCompletion: { completion in
                
                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished: XCTFail()
                case .failure(let error):
                    if case HTTPServiceError.HTTPEndpointNotValid = error {
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
