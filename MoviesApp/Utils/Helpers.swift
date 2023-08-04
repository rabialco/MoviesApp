//
//  Helpers.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation

struct Helpers {
    static func getBaseHeader() -> [String: String] {
        return ["accept": "application/json", "Authorization": "Bearer \(tokenAPI)"]
    }
    static func getYoutubeHeader() -> [String: String] {
        return ["accept": "application/json", "X-goog-api-key": "\(googleAPI)"]
    }
}
