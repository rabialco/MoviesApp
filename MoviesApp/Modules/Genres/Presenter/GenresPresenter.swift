//
//  GenresPresenter.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation
import UIKit

class GenresPresenter: GenresViewToPresenterProtocol {
    
    var view: GenresPresenterToViewProtocol?
        
    var interactor: GenresPresenterToInteractorProtocol?
    
    var router: GenresPresenterToRouterProtocol?
    
    func startFetchingGenres() {
        interactor?.fetchGenres()
    }
    
    func showMoviesController(navigationController: UINavigationController, selectedGenre: Genre) {
        print("selectedGenre in GenrePresenter : \(selectedGenre)")
        router?.pushToMoviesScreen(navigationConroller: navigationController, selectedGenre: selectedGenre)
    }

}

extension GenresPresenter: GenresInteractorToPresenterProtocol{
    
    func genresFetchedSuccess(genresModelArray: GenresModel) {
        view?.showGenres(genresArray: genresModelArray)
    }
    
    func genresFetchFailed() {
        view?.showError()
    }
    
    
}
