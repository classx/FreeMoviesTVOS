//
//  MockCategory.swift
//  PDMovieKitTests
//
//  Created by Peter Morris on 05/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation
@testable import PDMovieKit

class MockCategory: PDCategoryProtocol {
    static var categories: [PDCategory]?
    static var error: Error?
    static func allCategories(completion: ([PDCategory]?, Error?) -> Void) {
        completion(categories, error)
    }
}
