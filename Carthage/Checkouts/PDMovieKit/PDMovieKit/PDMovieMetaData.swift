//
//  PDMovieMetaData.swift
//  PDMovieKit
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

/// Represents a set of metadata about a particular movie. Most metadata
/// in the Archive.org database is optional, so the `identifer` and `description` are
/// guaranteed to be available for a particular. However, most movies do have `description`
/// and `credits`. `directorName`, and `runTime` are less common.
public struct PDMovieMetaData: Decodable {
    /// The identifier of the movie that the metadata is related to.
    internal let identifier: String
    /// The description of the movie.
    public let description: String
    /// The credits of the movie.
    public let credits: String?
    /// The name of the director.
    public let directorName: String?
    /// The number of minutes long the movie is.
    public let runTime: String?
    /// The URL where a thumbnail image for the movie may be retrieved.
    public var thumbnailURL: URL? {
        return URL(string: "https://archive.org/download/\(identifier)/__ia_thumb.jpg")
    }
    internal enum CodingKeys: String, CodingKey {
        case identifier, description, credits, runTime = "runtime", directorName = "director"
    }
}

/// Represents a metadata response from the `archive.org/metadata` endpoint. Response must
/// comprise only of a `metadata` container.
internal struct PDMovieMetaDataResponse: Decodable {
    let data: PDMovieMetaData
    enum CodingKeys: String, CodingKey {
        case data = "metadata"
    }
}
