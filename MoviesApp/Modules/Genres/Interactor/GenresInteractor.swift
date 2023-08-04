//
//  GenresInteractor.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation
import Moya

class GenresInteractor: GenresPresenterToInteractorProtocol{
    var presenter: GenresInteractorToPresenterProtocol?
    
    func fetchGenres() {
        apiManager.request(.getAllGenres) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data // Data, your JSON response is probably in here!
                let _ = moyaResponse.statusCode // Int - 200, 401, 500, etc

                do {
                    let genresDataDecoded = try JSONDecoder().decode(GenresModel.self, from: data)
                    self.presenter?.genresFetchedSuccess(genresModelArray: genresDataDecoded)
                }
                catch {
                    print("==================================")
                    print("Error JSONSerialization : \(error.localizedDescription)")
                    print("==================================\n")
                    self.presenter?.genresFetchFailed()
                }
            case let .failure(error):
                // TODO: handle the error == best. comment. ever.
                print("==================================")
                print("Error Fetch Genres : \(error.localizedDescription)")
                print("==================================\n")
                self.presenter?.genresFetchFailed()
            }
        }
    }
}
