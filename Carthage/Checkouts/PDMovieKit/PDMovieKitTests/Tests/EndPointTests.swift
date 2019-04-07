//
//  EndPointTests.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import XCTest
@testable import PDMovieKit

class EndPointTests: XCTestCase {
    
    var movie: PDMovie!
    var category: PDCategory!
    
    override func setUp() {
        let movieData = "{\"identifier\": \"fakeid\",\"title\": \"Test\", \"description\": \"\", \"avg_rating\": \"4.5\"}".data(using: .utf8)
        movie = try? JSONDecoder.init().decode(PDMovie.self, from: movieData!)
        let categoryData = """
        {
            "name": "Drama",
            "thumbnailURL": "",
            "tags": ["Drama", "drama", "dramas"]
        }
        """.data(using: .utf8)
        category = try? JSONDecoder.init().decode(PDCategory.self, from: categoryData!)
    }
    
    func test_meta_data_url() {
        let endPoint = ArchiveEndPoint.metaData(movie: movie!)
        XCTAssertNotNil(endPoint.url)
        XCTAssertEqual(endPoint.url!.description, "https://archive.org/metadata/fakeid")
    }
    
    func test_movies_url_page() {
        let endPoint = ArchiveEndPoint.movies(category: category, page: 1)
        XCTAssertNotNil(endPoint.url)
        XCTAssertTrue(endPoint.url!.description.contains("&page=1"))
    }
    
    func test_movies_url_subjects() {
        let endPoint = ArchiveEndPoint.movies(category: category, page: 1)
        XCTAssertTrue(endPoint.url!.description.contains("subject:(Drama%20OR%20drama%20OR%20dramas)"))
    }
    
    func test_movies_url_single_subject() {
        let category = try! JSONDecoder.init().decode(PDCategory.self, from: """
        {
            "name": "Drama",
            "thumbnailURL": "",
            "tags": ["Drama"]
        }
        """.data(using: .utf8)!)
        let endPoint = ArchiveEndPoint.movies(category: category, page: 1)
        XCTAssertTrue(endPoint.url!.description.contains("subject:(Drama)"))
    }
    
    func test_movies_url() {
        let endPoint = ArchiveEndPoint.movies(category: category, page: 2)
        XCTAssertEqual(endPoint.url!.description, "https://archive.org/advancedsearch.php?q=collection:(feature_films)%20AND%20mediatype:(movies)%20AND%20subject:(Drama%20OR%20drama%20OR%20dramas)&fl%5B%5D=identifier&fl%5B%5D=avg_rating&fl%5B%5D=description&fl%5B%5D=title&rows=50&output=json&page=2&sort%5B%5D=downloads%20desc&sort%5B%5D=&sort%5B%5D=")
    }
    
    func test_recently_added_url() {
        let endPoint = ArchiveEndPoint.recentlyAdded
        XCTAssertEqual(endPoint.url!.description, "https://archive.org/advancedsearch.php?q=collection:(feature_films)%20AND%20mediatype:(movies)&fl%5B%5D=identifier&fl%5B%5D=avg_rating&fl%5B%5D=description&fl%5B%5D=title&rows=50&output=json&page=1&sort%5B%5D=addeddate%20desc&sort%5B%5D=&sort%5B%5D=")
    }
    
    func test_most_watched_url() {
        let endPoint = ArchiveEndPoint.mostWatched
        XCTAssertEqual(endPoint.url!.description, "https://archive.org/advancedsearch.php?q=collection:(feature_films)%20AND%20mediatype:(movies)&fl%5B%5D=identifier&fl%5B%5D=avg_rating&fl%5B%5D=description&fl%5B%5D=title&rows=50&output=json&page=1&sort%5B%5D=downloads%20desc&sort%5B%5D=&sort%5B%5D=")
    }
    
    func test_top_rated_url() {
        let endPoint = ArchiveEndPoint.topRated
        XCTAssertEqual(endPoint.url!.description, "https://archive.org/advancedsearch.php?q=collection:(feature_films)%20AND%20mediatype:(movies)&fl%5B%5D=identifier&fl%5B%5D=avg_rating&fl%5B%5D=description&fl%5B%5D=title&rows=50&output=json&page=1&sort%5B%5D=avg_rating%20desc&sort%5B%5D=&sort%5B%5D=")
    }
    
}
