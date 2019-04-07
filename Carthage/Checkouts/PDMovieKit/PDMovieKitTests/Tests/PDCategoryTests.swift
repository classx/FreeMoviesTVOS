//
//  PDCategoryTests.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 29/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import XCTest
@testable import PDMovieKit

class PDCategoryTests: XCTestCase {

    var category: PDCategory!
    var session: MockURLSession!
    
    override func setUp() {
        let categoryData = """
        {
            "name": "Drama",
            "thumbnailURL": "",
            "tags": ["Drama", "drama", "dramas"]
        }
        """.data(using: .utf8)
        category = try? JSONDecoder.init().decode(PDCategory.self, from: categoryData!)
        session = MockURLSession()
    }
    
    func test_category_json_file_missing_error_thrown_for_invalid_file() {
        do {
            let _ = try PDCategory.categories(decoder: JSONDecoder(), jsonFileName: "fake")
        } catch {
            XCTAssertEqual(error as NSError, PDCategory.Errors.categoryJSONFileMissing)
        }
    }
    
    func test_categories_decoded_successfully() {
        let exp = expectation(description: "categories")
        PDCategory.allCategories { (categories, error) in
            XCTAssert(categories != nil && error == nil)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_movies_retrieval_enum() {
        let exp = expectation(description: "movies enum")
        category.movies(page: 2, session: session) { (movies, error) in
            XCTAssertTrue(self.session.url!.description.contains("dramas"))
            XCTAssertTrue(self.session.url!.description.contains("drama"))
            XCTAssertTrue(self.session.url!.description.contains("Drama"))
            XCTAssertTrue(self.session.url!.description.contains("page=2"))
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_movies_completes_on_correct_queue() {
        let exp = expectation(description: "movies enum")
        let queue = OperationQueue()
        category.movies(page: 1, session: session, completionQueue: queue) { (_, _) in
            XCTAssertEqual(OperationQueue.current!, queue)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.0)
    }
    
    func test_movies_completes_with_error() {
        let exp = expectation(description: "movies")
        session.returnError = NSError(domain: "", code: 0, userInfo: nil)
        session.returnData = nil
        category.movies(page: 1, session: session) { (_, error) in
            XCTAssertEqual(self.session.returnError as NSError?, error as NSError?)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_movies_completion_with_array() {
        let exp = expectation(description: "movies")
        session.returnError = nil
        session.returnData = "{\"response\": { \"docs\": [{\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}]}}".data(using: .utf8)
        category.movies(page: 1, session: session) { (movies, _) in
            XCTAssertEqual(movies!.count, 1)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_equatable_true() {
        XCTAssertTrue(category == category)
    }
    
    func test_equatable_false() {
        let categoryData = """
        {
            "name": "Action",
            "thumbnailURL": "",
            "tags": ["Drama", "drama", "dramas"]
        }
        """.data(using: .utf8)
        let anotherCategory = try? JSONDecoder.init().decode(PDCategory.self, from: categoryData!)
        XCTAssertFalse(category == anotherCategory!)
    }

}
