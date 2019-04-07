//
//  MockDecoder.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

class MockJSONDecoder: JSONDecoder {
    var throwError: Error?
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        if let error = throwError {
            throw error
        } else {
            return try super.decode(type, from: data)
        }
    }
}
