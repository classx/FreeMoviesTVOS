# PDMovieKit
## Free public domain movies for iOS and tvOS

### Table of Contents

- [PDMovieKit](#pdmoviekit)
  - [Free public domain movies for iOS and tvOS](#free-public-domain-movies-for-ios-and-tvos)
    - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Installing PDMovieKit](#installing-pdmoviekit)
    - [Carthage](#carthage)
    - [CocoaPods](#cocoapods)
  - [Getting Started](#getting-started)
    - [1) Import PDMovieKit](#1-import-pdmoviekit)
    - [Carthage](#carthage-1)
    - [CocoaPods](#cocoapods-1)
    - [2) List movie categories](#2-list-movie-categories)
    - [3) List movies within a category](#3-list-movies-within-a-category)
    - [4) Get the metadata for a movie](#4-get-the-metadata-for-a-movie)
  - [Issues and Requests](#issues-and-requests)

## Introduction

PDMovieKit is a simple framework for both iOS and tvOS which gives your app access to hundreds of free, public domain movies from the Internet Archive project.

## Installing PDMovieKit

### Carthage

Add PDMovieKit as a dependency in your project's `Cartfile`:

```
github "p-morris/PDMovieKit" ~> 1.0.0
```

Build your project's dependencies using Carthage:

```
carthage update
```

Once the build process is complete, drag either the iOS (`PDMovieKit.framework`) or tvOS (`PDMovieKit_tvOS.framework`) file to your project from the Carthage build folder.

Make sure that the PDMovieKit framework is listed in the `Linked Libraries and Frameworks` section of your project's settings.

Switch to the `Build Phases` tab, and add a new `Run Scipt` phase:

```
/usr/local/bin/carthage copy-frameworks
```

Under `Input Files`, add the appropriate input framework file for either iOS or tvOS.

For tvOS, add: `$(SRCROOT)/Carthage/Build/tvOS/PDMovieKit_tvOS.framework`

For iOS, add: `$(SRCROOT)/Carthage/Build/iOS/PDMovieKit.framework`

Under `Output Files`, add the appropriate output filename for either iOS or tvOS:

For tvOS, add: `$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/PDMovieKit_tvOS.framework`

For iOS, add: `$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/PDMovieKit.framework`

Note: you may add the input and output files to an existing `Run Script` phase along with your other Carthage dependancies, if you already added one previously.

### CocoaPods

Add PDMovieKit to your Podfile:

```
pod 'PDMovieKit'
```

Install PDMovie by running:

```
pod install
```

## Getting Started

### 1) Import PDMovieKit

### Carthage

For Carthage users, if you're using PDMovieKit in an iOS project, use the following `import`:

```
import PDMovieKit
```

For tvOS, use:

```
import PDMovieKit_tvOS
```

### CocoaPods

CocoaPods users can use the follow `import` for both iOS *and* tvOS:

```
import PDMovieKit
```

### 2) List movie categories

In PDMovieKit, movies belong to a set of categories. You can access an array of `PDCategory` objects using the `allCategories(completion:)` static method of the `PDCategory` class:

```
PDCategory.allCategories { (categories, error) in
  if let categories = categories {
      // Show the categories to the user
  }
}
```

A `PDCategory` is a very simple data structure, comprising of `name` and `thumbnail` properties.

The `name` property is a `String` representing the name of the category.

The `thumbnail` property is a `String` representing the remote path of a thumbnail which can be used to represent the category, if required. Create a `URL` using this `thumbnail` property, and make a request to download the image file in order to display it.

### 3) List movies within a category

You can access an array of `PDMovie` objects using the `movies(page:session:completionQueue:completion:)` function of a particular `PDCategory` object:

```
horrorCategory.movies(page: 1, session: URLSession.shared, completionQueue: OperationQueue.main, completion: { (movies, error) in
  if let movies = movies {
    // Display list of movies to the user
  }
})
```

Important! The request will be made, and the `completion` closure executed on a background queue. You can specify the queue that you'd like your `completion` closure to be executed on by passing in an `OperationQueue` object for the `completionQueue` argument.

A `PDMovie` object is a simple data structure comprising of `title`, `description`, `rating`, `thumbnailURL` and `watchURL` properties.

- The `title` is a `String` representing the title of the movie.
- The `description` is a `String` representing the description of the movie.
- The `rating` is a `Double` representing the review rating of the movie, between 0.0 and 5.0.
- The `thumbnailURL` is a remote `URL` at which a thumbnail image for the movie can be found.
- The `watchURL` is the URL which can be used to play the movie in `h.264` format.

### 4) Get the metadata for a movie

Each `PDMovie` has an associated `PDMovieMetaData` object associated with it, which provides a set of optional properties describing the movie further.

To retrieve the `PDMovieMetaData` object for a particular movie, use the `metaData(session:completionQueue:completion:)` method of any `PDMovie` object:

```
nightOfTheLivingDead.metaData(session: URLSession.shared, completionQueue: OperationQueue.main, completion: { (metaData, error) in
  if let metaData = metaData {
      // Show metadata to the user
  }
})
```

A `PDMovieMetaData` is another simple data structure, comprising of `description`, `credits`, `directorName`, `runTime`, and `thumbnailURL` properties.

- The `description` property is a `String` representing the description of the movie.
- The `credits` property is an optional `String?` representing the movie credits.
- The `directorName` is an optional `String?` representing the director of the movie.
- The `runTime` is an optional `String?` representing the amount of the time the movie lasts.
- The `thumbnailURL` is an remote `URL` at which a thumbnail image for the movie may be found.

## Issues and Requests

If you come across any bugs, or there is a particular feature that you'd like to see support for, then please file a Github issue and I'll get back to you.