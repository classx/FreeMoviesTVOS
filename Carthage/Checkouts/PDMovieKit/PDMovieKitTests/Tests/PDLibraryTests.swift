//
//  PDLibraryTests.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 05/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import XCTest
@testable import PDMovieKit

class PDLibraryTests: XCTestCase {
    
    var session: MockDecodableSession!
    var recentlyAdded: PDMovieResponse!
    var mostWatched: PDMovieResponse!
    var topRated: PDMovieResponse!
    var categories: [PDCategory]!
    var categoryType: PDCategoryProtocol.Type!
    
    override func setUp() {
        categoryType = MockCategory.self
        MockCategory.categories = nil
        MockCategory.error = nil
        session = MockDecodableSession()
        let data = "{ \"response\": { \"docs\": [{\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}, {\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}, {\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}, {\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}, {\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}, {\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}, {\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}] } }".data(using: .utf8)
        categories = try! JSONDecoder.init().decode([PDCategory].self, from: """
        [{
            "name": "Drama",
            "thumbnailURL": "",
            "tags": ["Drama"]
        },
        {
            "name": "Drama",
            "thumbnailURL": "",
            "tags": ["Drama"]
        }]
        """.data(using: .utf8)!)
        recentlyAdded = try? JSONDecoder().decode(PDMovieResponse.self, from: data!)
        mostWatched = try? JSONDecoder().decode(PDMovieResponse.self, from: data!)
        topRated = try? JSONDecoder().decode(PDMovieResponse.self, from: data!)
    }
    
    func test_failure_no_error_returns_fallback_error() {
        let exp = expectation(description: "fallback error")
        PDLibrary.library(categoryType: categoryType, session: session, completionQueue: OperationQueue.main) { (library, error) in
            XCTAssertEqual(error! as NSError, PDLibrary.Errors.loading)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_category_failure_returns_category_error() {
        let exp = expectation(description: "category failure")
        MockCategory.error = NSError(domain: "FakeCategoryError", code: 0, userInfo: nil)
        PDLibrary.library(categoryType: categoryType, session: session, completionQueue: OperationQueue.main) { (library, error) in
            XCTAssertEqual(error! as NSError, MockCategory.error! as NSError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_recently_added_failure_returns_error() {
        let exp = expectation(description: "recently failure")
        session.recentlyAddedError = NSError(domain: "fakerecenterror", code: 0, userInfo: nil)
        PDLibrary.library(categoryType: categoryType, session: session, completionQueue: OperationQueue.main) { (library, error) in
            XCTAssertEqual(error! as NSError, self.session.recentlyAddedError! as NSError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_most_watched_failure_returns_error() {
        let exp = expectation(description: "most watched failure")
        session.mostWatchedError = NSError(domain: "fakewatchederror", code: 0, userInfo: nil)
        PDLibrary.library(categoryType: categoryType, session: session, completionQueue: OperationQueue.main) { (library, error) in
            XCTAssertEqual(error! as NSError, self.session.mostWatchedError! as NSError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_top_rated_failure_returns_error() {
        let exp = expectation(description: "top rated failure")
        session.topRatedError = NSError(domain: "faketopratederror", code: 0, userInfo: nil)
        PDLibrary.library(categoryType: categoryType, session: session, completionQueue: OperationQueue.main) { (library, error) in
            XCTAssertEqual(error! as NSError, self.session.topRatedError! as NSError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_successful_response() {
        let exp = expectation(description: "successful library")
        session.topRatedError = nil
        session.mostWatchedError = nil
        session.recentlyAddedError = nil
        session.topRatedResponse = topRated
        session.mostWatchedResponse = mostWatched
        session.recentlyAddedResponse = recentlyAdded
        MockCategory.categories = categories
         PDLibrary.library(categoryType: categoryType, session: session, completionQueue: OperationQueue.main) { (library, error) in
            XCTAssertEqual(library!.featured.count, 5)
            XCTAssertEqual(library!.recentlyAdded.count, self.recentlyAdded.docs.count - 5)
            XCTAssertEqual(library!.mostWatched.count, self.mostWatched.docs.count)
            XCTAssertEqual(library!.topRated.count, self.topRated.docs.count)
            XCTAssertEqual(library!.categories.count, self.categories.count)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

}

