//
//  DependancyInversion.swift
//  This file contains extensions used to decouple this project's dependancies from view
//  and interaction layers. This inversion of dependancies creates a boundary between view/interaction
//  layer's of this project, and the frameworks on which this project depends. 
//
//  Created by Peter Morris on 07/04/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation
import PDMovieKit_tvOS

/// Used to decouple presentation/interaction layers from the `PDCategory` class of
/// the `PDMOvieKit` framework.
extension PDCategory: Item {
    /// The title of the category
    var title: String {
        return name
    }
    /// Categories do not have a thumbnail in this application
    var thumbnailURL: URL? {
        return nil
    }
}

/// Used to decouple presentation/interaction layers from the `PDMovie` class of
/// the `PDMOvieKit` framework.
extension PDMovie: Item { }
