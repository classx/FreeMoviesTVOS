//
//  URLBuilder.swift
//  PDMovieKit
//
//  Created by Peter Morris on 05/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

extension String {
    /**
     Initializes an HTML-escpaped `String` which represents the path to the Archive.org `/advancedsearch` end point.
     - Parameters:
        - query: The query string to filter the search by. Allows the format:
     `q=collection:(feature_films)%20AND%20mediatype:(movies)%20AND%20subject:(horror%20OR%20scary)`
        - page: The page of results to retrieve
        - sorting: The sorting parameter, should be in format `&sort[]=addeddate%20desc&sort[]=&sort[]=`.
        No sorting is applied if `nil`.
     */
    init(query: String, page: Int, sorting: String?) {
        self = """
        https://archive.org/advancedsearch.php?\
        q=\(query)\
        &fl[]=identifier\
        &fl[]=avg_rating\
        &fl[]=description\
        &fl[]=title\
        &rows=50\
        &output=json\
        &page=\(page)\
        \(sorting ?? "")
        """.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
}

extension URL {
    /// Used to represent the filters which can applied to an Archive.org advanced search.
    enum Filter {
        /// Specifies that only items in the `feature_films` collection should be included.
        case featureFilms
        /// Specifies that only items with a media type of movie should be included.
        case movieMediaType
        /// Specifies that only items with the specified subjects should be included.
        case includeSubjects(subjects: [String])
        /// - returns: A `String` representing the given `Filter`.
        func string() -> String {
            switch self {
            case .featureFilms: return "collection:(feature_films)"
            case .movieMediaType: return "mediatype:(movies)"
            case let .includeSubjects(subjects): return "subject:(\(subjects.joined(separator: " OR ")))"
            }
        }
    }
    /// Used to represent the order in which Archive.org advanced search results should be sorted
    enum Sorting: String {
        /// Specifies that the results should be sorted by descending number of downloads
        case downloads = "&sort[]=downloads desc&sort[]=&sort[]="
        /// Specifies that the results should be sorted by descending average rating
        case averageRating = "&sort[]=avg_rating desc&sort[]=&sort[]="
        /// Specifies that the results should be sorted by descending added date
        case addedDate = "&sort[]=addeddate desc&sort[]=&sort[]="
    }
    /**
     Initializes a `URL` representing an Archive.org advanced search.
     
     Archive.org advanced search may include a set of filters, sorting and are paginated with a maximum
     of 50 results per page.
     
     - Parameters:
        - filters: The filters that should be used to filter the search results
        - sortedBy: The `Sortign` that should be appliled to the results.
        - page: The page number of results that are required..
     */
    init?(with filters: [Filter], sortedBy: Sorting = .downloads, page: Int = 1) {
        let query = filters.map({ $0.string() }).joined(separator: " AND ")
        let path = String(query: query, page: page, sorting: sortedBy.rawValue)
        if let url = URL(string: path) {
            self = url
        } else {
            return nil
        }
    }
}
