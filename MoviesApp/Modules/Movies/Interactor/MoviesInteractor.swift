//
//  MoviesInteractor.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation
import Moya

class MoviesInteractor: MoviesPresenterToInteractorProtocol{
    
    var presenter: MoviesInteractorToPresenterProtocol?
    
    func fetchMoviesbyGenres(page: Int, selectedGenre: Genre) {
        apiManager.request(.getMoviesByGenreId(page: page, genreId: selectedGenre.id)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data // Data, your JSON response is probably in here!
                let _ = moyaResponse.statusCode // Int - 200, 401, 500, etc

                do {
                    let moviesDataDecoded = try JSONDecoder().decode(MoviesModel.self, from: data)
                    self.presenter?.moviesFetchedSuccess(moviesModelArray: moviesDataDecoded)
                }
                catch {
                    print("==================================")
                    print("Error JSONSerialization : \(error.localizedDescription)")
                    print("==================================\n")
                    self.presenter?.moviesFetchFailed()
                }
            case let .failure(error):
                // TODO: handle the error == best. comment. ever.
                print("==================================")
                print("Error Get Movies by Genres : \(error.localizedDescription)")
                print("==================================\n")
                self.presenter?.moviesFetchFailed()
            }
        }
    }
}
