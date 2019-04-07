//
//  Category.swift
//  PDMovieKit
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

/// Used to represent a movie category, in which a library of movies exists. A movie
/// may belong to multiple categories. There is no concept of a category in the Archive.org
/// database. Instead, movies are grouped in collections by tag. Since the tags are user-created
/// and case-sensitive, there is a lot of duplication. The purpose of the `PDCategory` class is to
/// group together related tags (i.e. Horror, horror, scary, Scary Movies) and provide an interface
/// more aking to the Movie genres that user's usually expect to find.
public final class PDCategory: Decodable {
    /// The category's name - i.e. Horror, Action etc
    public let name: String
    /// The URL of a thumbnail used to represent the category
    public let thumbnailURL: String
    /// The collection tags that represent this category
    internal let tags: [String]
    internal enum CodingKeys: String, CodingKey {
        case name, thumbnailURL, tags
    }
    /// Errors associated with inflating categories from the disk
    internal enum Errors {
        /// The domain for PDCategory errors
        static var domain = "PDCategoryErrorDomain"
        /// Represents an error loading the categopries JSON file from disk
        static var categoryJSONFileMissing = NSError(
            domain: domain,
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Failed to load categories from disk"]
        )
    }
    /**
     Used to access an array of all categories to which movies can belong.
     - Parameter completion: The code block to be executed on completion of the request. Includes parameters
     for the array of categories (if retrieved successfully), or an error if one occured.
     */
    public static func allCategories(completion: ([PDCategory]?, Error?) -> Void) {
        do {
            let categories = try self.categories()
            completion(categories, nil)
        } catch {
            completion(nil, error)
        }
    }
    /**
     Fetches the `categories.json` file from the disk and then attempts to parse it for `PDCategories`.
     - Parameters:
        - decoder: The `JSONDecoder` to use for parsing the file for decodable objects.
        - jsonFileName: The filename of the JSON file to load from disk.
        - bundle: The `Bundle` which the file can be found in.
     - Returns: An array of `PDCategory` objects.
     - Throws: `PDCategory.Errors.categoryJSONFileMissing` if `jsonFileName` can't be loaded from disk.
     */
    internal static func categories(decoder: JSONDecoder = JSONDecoder(),
                                    jsonFileName: String = "categories",
                                    bundle: Bundle = Bundle(for: PDCategory.self)) throws -> [PDCategory] {
        guard let url = bundle.url(forResource: jsonFileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let categories = try? decoder.decode([PDCategory].self, from: data) else {
                throw Errors.categoryJSONFileMissing
        }
        return categories
    }
    /**
     Fetches an array of movies associated with this category.
     
     Each category contains hundreds of movies, and therefore retrieval is limited to 50 movies
     per page.
     
     - Parameters:
        - page: The page number required.
        - session: The `URLSession` to use for the request.
        - completionQueue: The `OperationQueue` on which to execute `completion`.
        - completion: The code block to be executed asynchronously on `completionQueue` once the request is complete.
            Includes parameter for the movie array (if retrieved successfully), or an error if not.
     */
    public func movies(page: Int,
                       session: URLSession = URLSession.shared,
                       completionQueue: OperationQueue = OperationQueue.main,
                       completion: @escaping ([PDMovie]?, Error?) -> Void) {
        let endPoint = ArchiveEndPoint.movies(category: self, page: page)
        session.decodableRequest(with: endPoint) { (response: PDMovieResponse?, error) in
            completionQueue.addOperation {
                completion(response?.docs, error)
            }
        }
    }
}

extension PDCategory: Equatable {
    /// Two categories are equal if their names are equal
    public static func == (lhs: PDCategory, rhs: PDCategory) -> Bool {
        return lhs.name == rhs.name
    }
}
