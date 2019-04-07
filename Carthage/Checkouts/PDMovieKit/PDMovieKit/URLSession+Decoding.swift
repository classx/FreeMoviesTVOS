//
//  URLSession+Decoding.swift
//  PDMovieKit
//
//  Created by Peter Morris on 28/03/2019.
//  Copyright © 2019 Pete Morris. All rights reserved.
//

import Foundation

/// Adds generic functionality to URLSession for performing a data task
/// and parsing the response body for JSON decodable objects.
internal extension URLSession {
    /// Contains errors to be thrown when encountering errors parsing responses
    enum Errors {
        static var invalidURL = NSError(
            domain: "URLSesssionErrorDomain",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "Invalid URL."]
        )
    }
    /**
     Makes a data request to the `URL` specified by a given `EndPoint`, and then
     attempts to parse the response body for JSON data which can be decoded to a `Decodable` type.
     - Parameters:
          - endPoint: The `EndPoint` representing the request URL.
          - decoder: The `JSONDecoder` to use for decoding the response body into a `Decodable` object.
          - completion: The block of code to execute on completion of the request/decoding operation. Includes
                        the object that was decoded (or `nil` if an error occured), and an `Error` if one occured.
      - warning: Both the request and completion will be executed on a background queue.
     */
    func decodableRequest<T>(with endPoint: EndPoint,
                             decoder: JSONDecoder = JSONDecoder(),
                             completion: @escaping (T?, Error?) -> Void) where T: Decodable {
        guard let url = endPoint.url else { completion(nil, Errors.invalidURL); return; }
        dataTask(with: url) { (data, response, error) in
            do {
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                let response = try decoder.decode(T.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
