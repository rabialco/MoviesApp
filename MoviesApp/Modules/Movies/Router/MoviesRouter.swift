//
//  MoviesRouter.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation
import UIKit

class MoviesRouter: MoviesPresenterToRouterProtocol{
    
    static func createModule(selectedGenre: Genre) -> MoviesViewController {
        
        let view = MoviesViewController()
        
        let presenter: MoviesViewToPresenterProtocol & MoviesInteractorToPresenterProtocol = MoviesPresenter()
        let interactor: MoviesPresenterToInteractorProtocol = MoviesInteractor()
        let router: MoviesPresenterToRouterProtocol = MoviesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.selectedGenre = selectedGenre
        
        return view
        
    }
    
    func pushToMovieDetailScreen(navigationConroller navigationController:UINavigationController, selectedMovie: Movie) {

        let movieDetailModule = MovieDetailRouter.createMovieModule(selectedMovie: selectedMovie)
        navigationController.pushViewController(movieDetailModule,animated: true)

    }
    
}
