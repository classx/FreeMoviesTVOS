//
//  URLBuildingTests.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 05/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import XCTest
@testable import PDMovieKit

class URLBuildingTests: XCTestCase {
    
    func test_string_init_no_sorting() {
        let string = String(query: "test_query", page: 10, sorting: nil)
        XCTAssertTrue(string.contains("q=test_query"))
        XCTAssertTrue(string.contains("page=10"))
        XCTAssertFalse(string.contains(" "))
        let array = string.components(separatedBy: "page=10")
        XCTAssertFalse(array.first!.contains("page=10"))
        XCTAssertEqual(array.last!, "")
    }
    
    func test_string_init_with_sorting() {
        let string = String(query: "test_query", page: 10, sorting: "sort_test")
        XCTAssertTrue(string.contains("q=test_query"))
        XCTAssertTrue(string.contains("page=10"))
        XCTAssertFalse(string.contains(" "))
        let array = string.components(separatedBy: "page=10")
        XCTAssertFalse(array.first!.contains("page=10"))
        XCTAssertEqual(array.last!, "sort_test")
    }
    
    func test_feature_films_filter_string() {
        let filter = URL.Filter.featureFilms
        XCTAssertEqual(filter.string(), "collection:(feature_films)")
    }
    
    func test_movie_media_type_filter_string() {
        let filter = URL.Filter.movieMediaType
        XCTAssertEqual(filter.string(), "mediatype:(movies)")
    }
    
    func test_subjects_filter_string() {
        let filter = URL.Filter.includeSubjects(subjects: ["one", "two"])
        XCTAssertEqual(filter.string(), "subject:(one OR two)")
    }
    
    func test_sorting_downloads_string() {
        XCTAssertEqual(URL.Sorting.downloads.rawValue, "&sort[]=downloads desc&sort[]=&sort[]=")
    }
    
    func test_sorting_average_rating_string() {
        XCTAssertEqual(URL.Sorting.averageRating.rawValue, "&sort[]=avg_rating desc&sort[]=&sort[]=")
    }
    
    func test_sorting_added_date_string() {
        XCTAssertEqual(URL.Sorting.addedDate.rawValue, "&sort[]=addeddate desc&sort[]=&sort[]=")
    }
    
    func test_init_URL_init() {
        let url = URL(with: [.featureFilms, .movieMediaType, .includeSubjects(subjects: ["test_one", "test_two"])], sortedBy: .addedDate, page: 10)
        XCTAssertTrue(url!.description.contains("q=collection:(feature_films)%20AND%20mediatype:(movies)%20AND%20subject:(test_one%20OR%20test_two)"))
        XCTAssertTrue(url!.description.contains("page=10"))
        XCTAssertTrue(url!.description.contains("sort%5B%5D=addeddate%20desc&sort%5B%5D=&sort%5B%5D="))
    }

    
}
