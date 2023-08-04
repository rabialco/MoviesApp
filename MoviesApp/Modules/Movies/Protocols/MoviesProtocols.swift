//
//  MoviesProtocols.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation
import UIKit

protocol MoviesViewToPresenterProtocol: AnyObject{ // Any Presenter
    
    var view: MoviesPresenterToViewProtocol? { get set }
    var interactor: MoviesPresenterToInteractorProtocol? { get set }
    var router: MoviesPresenterToRouterProtocol? { get set }
    var selectedGenre: Genre? { get set }
    
    func startFetchingMovies(page: Int)
    func showMovieDetailController(navigationController: UINavigationController, selectedMovie: Movie)

}

protocol MoviesPresenterToViewProtocol: AnyObject { // Any View
    var presenter: MoviesViewToPresenterProtocol? { get set }
    
    func showMovies(moviesArray: MoviesModel)
    func showError()
}

protocol MoviesPresenterToRouterProtocol: AnyObject { // Any Router
    
    static func createModule(selectedGenre: Genre)-> MoviesViewController
    func pushToMovieDetailScreen(navigationConroller: UINavigationController, selectedMovie: Movie)
}

protocol MoviesPresenterToInteractorProtocol: AnyObject { // Any Interactor
    var presenter: MoviesInteractorToPresenterProtocol? { get set }
    func fetchMoviesbyGenres(page: Int, selectedGenre: Genre)
}

protocol MoviesInteractorToPresenterProtocol: AnyObject {
    func moviesFetchedSuccess(moviesModelArray: MoviesModel)
    func moviesFetchFailed()
}

