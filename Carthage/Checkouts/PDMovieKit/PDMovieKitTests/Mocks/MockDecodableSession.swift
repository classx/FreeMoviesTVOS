//
//  MockDecodableSession.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 05/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation
@testable import PDMovieKit

class MockDecodableSession: DecodableSession {
    var recentlyAddedError: Error?
    var recentlyAddedResponse: PDMovieResponse?
    var mostWatchedError: Error?
    var mostWatchedResponse: PDMovieResponse?
    var topRatedError: Error?
    var topRatedResponse: PDMovieResponse?
    func decodableRequest<T>(with endPoint: EndPoint, decoder: JSONDecoder, completion: @escaping (T?, Error?) -> Void) where T : Decodable {
        let endPoint = endPoint as! ArchiveEndPoint
        switch endPoint {
        case .recentlyAdded: completion(recentlyAddedResponse as? T, recentlyAddedError)
        case .mostWatched: completion(mostWatchedResponse as? T, mostWatchedError)
        case .topRated: completion(topRatedResponse as? T, topRatedError)
        default: completion(nil, nil)
        }
    }
    
    
}
