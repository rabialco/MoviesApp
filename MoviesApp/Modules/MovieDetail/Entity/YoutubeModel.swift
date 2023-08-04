//
//  YoutubeModel.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 04/08/23.
//

import Foundation

struct YoutubeModel: Codable {
    let items: [VideoElement]?
}

struct VideoElement: Codable {
    let id: VideoID?
}

struct VideoID: Codable {
    let videoId: String?
}
