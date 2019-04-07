//
//  PDMovieMetaDataTests.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 29/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import XCTest
@testable import PDMovieKit

class PDMovieMetaDataTests: XCTestCase {

    var metadata: PDMovieMetaData!
    
    override func setUp() {
        let metadata = "{\"identifier\": \"fakeid\",\"director\": \"director name\", \"description\": \"\", \"credits\": \"test credits\", \"runtime\": \"60\"}".data(using: .utf8)
        self.metadata = try? JSONDecoder.init().decode(PDMovieMetaData.self, from: metadata!)
    }
    
    func test_optional_properties() {
        XCTAssertNotNil(metadata.credits)
        XCTAssertNotNil(metadata.directorName)
        XCTAssertNotNil(metadata.runTime)
    }
    
    func test_thumbnail_url() {
        XCTAssertEqual(metadata.thumbnailURL!.description, "https://archive.org/download/\(metadata.identifier)/__ia_thumb.jpg")
    }
    
    func test_init_without_optional_properties() {
        let metadata = "{\"identifier\": \"fakeid\", \"description\": \"\"}".data(using: .utf8)
        let metaObject = try? JSONDecoder.init().decode(PDMovieMetaData.self, from: metadata!)
        XCTAssertNotNil(metaObject)
        XCTAssertNil(metaObject!.credits)
        XCTAssertNil(metaObject!.directorName)
        XCTAssertNil(metaObject!.runTime)
    }
    
    func test_meta_data_response_init() {
        let responseData = "{ \"metadata\": {\"identifier\": \"fakeid\", \"description\": \"\"} }".data(using: .utf8)
        let response = try? JSONDecoder.init().decode(PDMovieMetaDataResponse.self, from: responseData!)
        XCTAssertNotNil(response)
    }

}
