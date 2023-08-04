//
//  APIManager.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation
import Moya

public enum APIManager {
    case getAllGenres
    case getMoviesByGenreId(page: Int, genreId: Int)
    case getMovieDetailById(movieID: Int)
    case getYoutubeTrailer(query: String)
    case getReviewsByMovieID(movieID: Int, page: Int)
}

let apiManager = MoyaProvider<APIManager>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

extension APIManager: TargetType {
    public var baseURL: URL {
        switch self {
        case .getYoutubeTrailer:
            return URL(string: youtubeBaseURL)!
        default :
            return URL(string: apiBaseURL)!
        }
        
    }
    
    public var path: String {
        switch self {
        case .getAllGenres:
            return "3/genre/movie/list"
        case .getMoviesByGenreId:
            return "3/discover/movie"
        case .getMovieDetailById(let movieID):
            return "3/movie/\(movieID)"
        case .getYoutubeTrailer:
            return "search"
        case .getReviewsByMovieID(let movieID, _):
            return "3/movie/\(movieID)/reviews"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getAllGenres, .getMoviesByGenreId, .getMovieDetailById, .getYoutubeTrailer, .getReviewsByMovieID:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getAllGenres, .getMovieDetailById:
            var params: [String: Any] = [:]
            params["language"] = "en"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getMoviesByGenreId(let page, let genreId):
            var params: [String : Any] = [:]
            params = ["page": page, "with_genres": genreId, "sort_by": "popularity.desc"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getYoutubeTrailer(let query):
            var params: [String : Any] = [:]
            params = ["q": "\(query) Trailer"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getReviewsByMovieID(_, let page):
            var params: [String : Any] = [:]
            params = ["page": page, "language": "en"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .getAllGenres, .getMoviesByGenreId, .getMovieDetailById, .getReviewsByMovieID:
            return Helpers.getBaseHeader()
        case .getYoutubeTrailer:
            return Helpers.getYoutubeHeader()
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}

