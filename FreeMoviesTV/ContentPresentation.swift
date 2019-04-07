//
//  ContentPresentation.swift
//  FreeMoviesTV
//
//  Created by Peter Morris on 07/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

/// Represents a single section of content to be displayed on the screen
protocol Shelf {
    /// The title of the section.
    var title: String { get }
    /// The items that the section contains.
    var items: [Item] { get }
}

/// Generic implementation of `Shelf`
struct ContentShelf: Shelf {
    let title: String
    let items: [Item]
}

/// Represents a single content item to be displayed on the screen.
protocol Item {
    /// The title of the content.
    var title: String { get }
    /// The URL at which a thumbnail which represents the content may be found.
    var thumbnailURL: URL? { get }
}

/// Represents a collection of sections, each containing a set of content items to be displayed on screen.
protocol ItemShelves {
    /// - returns: The number of sections to displayed on screen
    func numberOfShelves() -> Int
    /// - Parameter index: The index of the section for which the number of items
    /// within that section should be returned.
    /// - returns: The number of items within the section at the given index.
    func numberOfItemsOnShelf(index: Int) -> Int
    /// - Parameter index: The index of the section for which the title should be returned.
    /// - returns: A `String` representing the title of the section at the given index.
    func shelfTitle(index: Int) -> String
    /// - Parameters:
    ///     - itemIndex: The index of the item for which the title should be returned.
    ///     - shelfIndex: The index of the section in which the given item is contained.
    /// - returns: A `String` representing the title of the item at the given set of indexes.
    func itemTitle(at itemIndex: Int, onShelf shelfIndex: Int) -> String
}

/// Generic implementation of `ItemShelves`.
class ContentShelves: ItemShelves {
    /// The array of `Shelf` objects to be presented.
    private let shelves: [Shelf]
    /// Initializes an instance of `ContentShelves`.
    /// - Parameter content: An `Array` of `Shelf` objects to be presented.
    /// - returns: An initialized `ContentShelves` object.
    init(content: [Shelf] = []) {
        self.shelves = content
    }
    func numberOfShelves() -> Int {
        return shelves.count
    }
    func numberOfItemsOnShelf(index: Int) -> Int {
        return shelves[index].items.count
    }
    func shelfTitle(index: Int) -> String {
        return shelves[index].title.capitalized
    }
    func itemTitle(at itemIndex: Int, onShelf shelfIndex: Int) -> String {
        return shelves[shelfIndex].items[itemIndex].title.capitalized
    }
}
