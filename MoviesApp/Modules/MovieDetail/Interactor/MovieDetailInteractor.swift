//
//  MovieDetailInteractor.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 04/08/23.
//

import Foundation
import Moya

class MovieDetailInteractor: MovieDetailPresenterToInteractorProtocol{
    
    var presenter: MovieDetailInteractorToPresenterProtocol?
    
    func fetchMovieDetailByID(movieID: Int) {
        apiManager.request(.getMovieDetailById(movieID: movieID)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data // Data, your JSON response is probably in here!
                let _ = moyaResponse.statusCode // Int - 200, 401, 500, etc

                do {
                    let movieDetailDataDecoded = try JSONDecoder().decode(MovieDetailModel.self, from: data)
                    self.presenter?.movieDetailFetchedSuccess(movieDetailModelData: movieDetailDataDecoded)
                }
                catch {
                    print("==================================")
                    print("Error JSONSerialization : \(error.localizedDescription)")
                    print("==================================\n")
                    self.presenter?.movieDetailFetchFailed()
                }
            case let .failure(error):
                // TODO: handle the error == best. comment. ever.
                print("==================================")
                print("Error Fetch Movie Detail : \(error.localizedDescription)")
                print("==================================\n")
                self.presenter?.movieDetailFetchFailed()
            }
        }
    }
    
    func fetchYoutubeTrailerByTitle(title: String) {
        apiManager.request(.getYoutubeTrailer(query: title)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data // Data, your JSON response is probably in here!
                let _ = moyaResponse.statusCode // Int - 200, 401, 500, etc

                do {
                    let videoIDDataDecoded = try JSONDecoder().decode(YoutubeModel.self, from: data)
                    self.presenter?.youtubeTrailerFetchedSuccess(videoID: videoIDDataDecoded.items?.first?.id?.videoId ?? "12345678901")
                }
                catch {
                    print("==================================")
                    print("Error JSONSerialization : \(error.localizedDescription)")
                    print("==================================\n")
                    self.presenter?.youtubeTrailerFetchFailed()
                }
            case let .failure(error):
                // TODO: handle the error == best. comment. ever.
                print("==================================")
                print("Error Fetch Youtube Trailer : \(error.localizedDescription)")
                print("==================================\n")
                self.presenter?.youtubeTrailerFetchFailed()
            }
        }
    }

}

