//
//  MovieDetailRouter.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 04/08/23.
//

import Foundation
import UIKit

class MovieDetailRouter: MovieDetailPresenterToRouterProtocol{
    
    static func createMovieModule(selectedMovie: Movie) -> MovieDetailViewController {
        
        let view = MovieDetailViewController()
        
        let presenter: MovieDetailViewToPresenterProtocol & MovieDetailInteractorToPresenterProtocol = MovieDetailPresenter()
        let interactor: MovieDetailPresenterToInteractorProtocol = MovieDetailInteractor()
        let router: MovieDetailPresenterToRouterProtocol = MovieDetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.selectedMovie = selectedMovie
        
        return view
        
    }
    
    func pushToReviewsScreen(navigationConroller navigationController:UINavigationController, movieID: Int) {

        let reviewsModule = ReviewsRouter.createReviewsModule(movieID: movieID)
        navigationController.pushViewController(reviewsModule,animated: true)

    }
    
}
