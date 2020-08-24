//
//  ImageServiceTests.swift
//  SurfingSpotsTests
//
//  Created by Andrea Cerra on 8/24/20.
//  Copyright © 2020 Andrea Cerra. All rights reserved.
//

import XCTest

@testable import SurfingSpots

class ImageServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRetrieveImageValid() throws {
        
        // setup
        continueAfterFailure = false
        let expectation = XCTestExpectation(description: "Image downloaded")
        
        let httpService = HTTPServiceMock()
        httpService.jsonType = ResultType.ImageData
        
        let imageService = ImageService(httpService: httpService)
        
        let remoteDataPublisher = imageService.getImageForCity(city: "Rome")
            .sink(receiveCompletion: { completion in
                
                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished: expectation.fulfill()
                case .failure: XCTFail()
                }
                
            }, receiveValue: { image in
                                
                let imageOriginal = UIImage(imageLiteralResourceName: "city-placeholder")
                
                XCTAssert(imageOriginal.pngData() == image.pngData())
            })
        
        XCTAssertNotNil(remoteDataPublisher)
        wait(for: [expectation], timeout: 5.0)
    }

    func testHTTPConnectionDown() throws {
        
        // setup
        continueAfterFailure = false
        let expectation = XCTestExpectation(description: "Image downloaded")

        let httpService = HTTPServiceMock()
        httpService.validHTTPConnection = false
        
        let imageService = ImageService(httpService: httpService)

        let remoteDataPublisher = imageService.getImageForCity(city: "Rome")
            .sink(receiveCompletion: { completion in
                
                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished: XCTFail()
                case .failure(let error):
                    if case ImageServiceError.ImageRequestError = error {
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
