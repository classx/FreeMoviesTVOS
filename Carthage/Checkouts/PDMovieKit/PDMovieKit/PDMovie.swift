//
//  PDMovie.swift
//  PDMovieKit
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

/// Represents a movie in the Archive.org database, and a limited set of metadata
/// related to that movie. More metadata is available by making a seperate request
/// to the Archive.org database via the `metaData` function.
public struct PDMovie: Decodable {
    /// The identifier of the movie in the Archive.org database.
    internal let identifier: String
    /// The title of the movie.
    public let title: String
    /// The description of the movie.
    public let description: String
    /// The average rating of the movie. A value from 0.0 to 5.0.
    public let rating: Double
    /// The URL where a thumbnail image for the movie may be retrieved.
    public var thumbnailURL: URL? {
        return URL(string: "https://archive.org/download/\(identifier)/__ia_thumb.jpg")
    }
    /// The URL which can be used to stream the movie.
    public var watchURL: URL? {
        return URL(string: "https://archive.org/download/\(identifier)/format=h.264")
    }
    internal enum CodingKeys: String, CodingKey {
        case identifier, title, description, rating = "avg_rating"
    }
    /**
     Initializes a `PDMovie` object using a given `Decoder`.
     
     At a minimum, the decoder must be able to decode `identifier`, `title`, `description. The `avg_rating` is
     optional, and will default to 0.0 if none is found in the container.
     
     - Parameter decoder: The decoder to use for retrieving property values.
     */
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.title = try container.decode(String.self, forKey: .title)
        self.rating = try Double(container.decodeIfPresent(String.self, forKey: .rating) ?? "0.0") ?? 0.0
        // Archive.org data can be inconsistent for the `description` key.
        // Very rarely, this value will either be nil or an array.
        // So, provide a fallback description for these rare cases.
        do {
            self.description = try container.decode(String.self, forKey: .description)
        } catch {
            self.description = "\(self.title) - Rated: \(self.rating)"
        }
    }
    /**
     Fetches the metadata for the current movie.
     
     - Parameters:
        - session: The `URLSession` to use for the request.
        - completionQueue: The `OperationQueue` on which to execute `completion`.
        - completion: The code block to be executed asynchronously on `completionQueue` once the request is complete.
     Includes parameter for the returned `PDMetaData` (if retrieved successfully), or an error if not.
     */
    public func metaData(session: URLSession = URLSession.shared,
                         completionQueue: OperationQueue = OperationQueue.main,
                         completion: @escaping (PDMovieMetaData?, Error?) -> Void) {
        let endPoint = ArchiveEndPoint.metaData(movie: self)
        session.decodableRequest(with: endPoint) { (response: PDMovieMetaDataResponse?, error) in
            completionQueue.addOperation {
                completion(response?.data, error)
            }
        }
    }
}

/// Represents a response from the Archive.org/advanced_search endpoint, which
/// `PDMovieKit` uses to retrieve lists of movies within a given category.
internal struct PDMovieResponse: Decodable {
    /// The `PDMovie` objects in the response.
    internal let docs: [PDMovie]
    internal enum CodingKeys: String, CodingKey {
        case response, docs
    }
    /**
     Initializes a `PDMovie` object using a given `Decoder`.
     
     The decoder must be able to access a `response` container, and a `docs` array containing
     valid decodable `PDMovie` data.
     
     - Parameter decoder: The decoder to use for retrieving property values.
     */
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        docs = try response.decode([PDMovie].self, forKey: .docs)
    }
}
