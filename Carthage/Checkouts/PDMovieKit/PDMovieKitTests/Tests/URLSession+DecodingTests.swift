//
//  URLSession+DecodingTests.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import XCTest
@testable import PDMovieKit

class URLSessionDecodingTests: XCTestCase {
    
    var session: MockURLSession!
    var endPoint: MockEndPoint!
    var decoder: MockJSONDecoder!
    
    override func setUp() {
        session = MockURLSession()
        endPoint = MockEndPoint()
        decoder = MockJSONDecoder()
    }
    
    func test_invalid_url_returns_error() {
        let exp = expectation(description: "invalid url")
        endPoint.url = nil
        session.decodableRequest(with: endPoint) { (object: MockDecodable?, error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error! as NSError, URLSession.Errors.invalidURL)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_resume_invoked() {
        endPoint.url = URL(string: "https://google.com")
        session.decodableRequest(with: endPoint) { (object: MockDecodable?, error) in }
        XCTAssertTrue(session.returnedTask!.didResume)
    }
    
    func test_guards_when_return_data_nil() {
        let exp = expectation(description: "nil data")
        endPoint.url = URL(string: "https://google.com")
        session.returnData = nil
        session.returnError = NSError(domain: "", code: 0, userInfo: nil)
        session.decodableRequest(with: endPoint) { (object: MockDecodable?, error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(self.session.returnError! as NSError, error! as NSError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_decoder_throws_error() {
        let exp = expectation(description: "decoder throws")
        endPoint.url = URL(string: "https://google.com")
        session.returnData = Data()
        session.returnError = nil
        decoder.throwError = NSError(domain: "", code: 0, userInfo: nil)
        session.decodableRequest(with: endPoint, decoder: decoder) { (object: MockDecodable?, error) in
            XCTAssertNotNil(error)
            XCTAssertEqual(error! as NSError, self.decoder.throwError! as NSError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_valid_return_object() {
        let exp = expectation(description: "valid data")
        endPoint.url = URL(string: "https://google.com")
        session.returnData = "{}".data(using: .utf8)
        session.returnError = nil
        decoder.throwError = nil
        session.decodableRequest(with: endPoint, decoder: decoder) { (object: MockDecodable?, error) in
            XCTAssertNotNil(object)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
}
