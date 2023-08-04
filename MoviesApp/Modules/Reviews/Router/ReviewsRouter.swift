//
//  ReviewsRouter.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 05/08/23.
//

import Foundation
import UIKit

class ReviewsRouter: ReviewsPresenterToRouterProtocol{
    
    static func createReviewsModule(movieID: Int) -> ReviewsViewController {
        
        let view = ReviewsViewController()
        
        let presenter: ReviewsViewToPresenterProtocol & ReviewsInteractorToPresenterProtocol = ReviewsPresenter()
        let interactor: ReviewsPresenterToInteractorProtocol = ReviewsInteractor()
        let router: ReviewsPresenterToRouterProtocol = ReviewsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        presenter.movieID = movieID
        
        return view
        
    }

}

