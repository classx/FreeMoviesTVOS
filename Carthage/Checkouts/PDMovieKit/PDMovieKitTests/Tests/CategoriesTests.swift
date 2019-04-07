//
//  CategoriesTests.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import XCTest
@testable import PDMovieKit

class CategoriesTests: XCTestCase {
    
    let bundle = Bundle(for: PDCategory.self)
    var url: URL!
    var data: Data!
    
    override func setUp() {
        url = bundle.url(forResource: "categories", withExtension: "json")
        data = try? Data(contentsOf: url)
    }
    
    func test_categories_json_url() {
        XCTAssertNotNil(url)
    }
    
    func test_categories_json_data() {
        XCTAssertNotNil(data)
    }
    
    func test_categories_data_parses_to_json() {
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        XCTAssertNotNil(json)
    }
    
    func test_categories_json_parses_to_obects() {
        let decoder = JSONDecoder()
        let objects = try? decoder.decode([PDCategory].self, from: data)
        XCTAssertNotNil(objects)
    }
    
}
