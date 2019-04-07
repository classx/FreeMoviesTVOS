//
//  MockDecodable.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

class MockDecodable: Decodable {
    let initialized: Bool
    required public init(from decoder: Decoder) throws {
        initialized = true
    }
}
