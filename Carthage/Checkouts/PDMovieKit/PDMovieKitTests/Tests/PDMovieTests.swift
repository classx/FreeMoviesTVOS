//
//  PDMovieTests.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 29/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import XCTest
@testable import PDMovieKit

class PDMovieTests: XCTestCase {

    var movie: PDMovie!
    var session: MockURLSession!
    
    override func setUp() {
        let movieData = "{\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}".data(using: .utf8)
        movie = try? JSONDecoder.init().decode(PDMovie.self, from: movieData!)
        session = MockURLSession()
    }
    
    func test_init_succeeds_without_rating() {
        let movieData = "{\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\"}".data(using: .utf8)
        let movie = try? JSONDecoder.init().decode(PDMovie.self, from: movieData!)
        XCTAssertNotNil(movie)
        XCTAssertEqual(movie!.rating, 0.0)
    }
    
    func test_init_succeeds_with_invalid_rating() {
        let movieData = "{\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"invalidrating\"}".data(using: .utf8)
        let movie = try? JSONDecoder.init().decode(PDMovie.self, from: movieData!)
        XCTAssertNotNil(movie)
        XCTAssertEqual(movie!.rating, 0.0)
    }
    
    func test_url() {
        XCTAssertEqual(movie.watchURL!.description, "https://archive.org/download/\(movie.identifier)/format=h.264")
    }
    
    func test_metadata_retrieval_enum() {
        let exp = expectation(description: "metadata enum")
        movie.metaData(session: session) { (_, _) in
            XCTAssertTrue(self.session.url!.description.contains("/metadata/fakeid"))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_completion_executes_on_queue() {
        let exp = expectation(description: "metadata")
        let queue = OperationQueue()
        movie.metaData(session: session, completionQueue: queue) { (_, _) in
            XCTAssertEqual(OperationQueue.current!, queue)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_movies_completes_with_error() {
        let exp = expectation(description: "movies")
        session.returnError = NSError(domain: "", code: 0, userInfo: nil)
        session.returnData = nil
        movie.metaData(session: session) { (_, error) in
            XCTAssertEqual(self.session.returnError as NSError?, error as NSError?)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_movies_completion_with_object() {
        let exp = expectation(description: "movies")
        session.returnError = nil
        session.returnData = "{\"metadata\": { \"identifier\": \"fakeid\", \"description\": \"fake description\"}}".data(using: .utf8)
        movie.metaData(session: session) { (data, error) in
            XCTAssertEqual(data!.description, "fake description")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_response_init() {
        let data = "{ \"response\": { \"docs\": [{\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}, {\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}] } }".data(using: .utf8)
        let response = try? JSONDecoder().decode(PDMovieResponse.self, from: data!)
        XCTAssertEqual(response!.docs.count, 2)
    }

}
