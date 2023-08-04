//
//  MoviesPresenter.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation
import UIKit

class MoviesPresenter: MoviesViewToPresenterProtocol {
    
    var selectedGenre: Genre?
    
    var router: MoviesPresenterToRouterProtocol?
    
    var interactor: MoviesPresenterToInteractorProtocol?
    
    var view: MoviesPresenterToViewProtocol?
    
    func startFetchingMovies(page: Int) {
        interactor?.fetchMoviesbyGenres(page: page, selectedGenre: selectedGenre!)
    }
    
    func showMovieDetailController(navigationController: UINavigationController, selectedMovie: Movie) {
        router?.pushToMovieDetailScreen(navigationConroller: navigationController, selectedMovie: selectedMovie)
    }

}

extension MoviesPresenter: MoviesInteractorToPresenterProtocol{
    
    func moviesFetchedSuccess(moviesModelArray: MoviesModel) {
        view?.showMovies(moviesArray: moviesModelArray)
    }
    
    func moviesFetchFailed() {
        view?.showError()
    }
    
    
}

