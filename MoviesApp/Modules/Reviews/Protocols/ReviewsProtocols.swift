//
//  ReviewsProtocols.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 05/08/23.
//

import Foundation
import UIKit

protocol ReviewsViewToPresenterProtocol: AnyObject{ // Any Presenter
    
    var view: ReviewsPresenterToViewProtocol? { get set }
    var interactor: ReviewsPresenterToInteractorProtocol? { get set }
    var router: ReviewsPresenterToRouterProtocol? { get set }
    var movieID: Int? { get set }
    
    func startFetchingReviews(page: Int)

}

protocol ReviewsPresenterToViewProtocol: AnyObject { // Any View
    var presenter: ReviewsViewToPresenterProtocol? { get set }
    
    func showReviews(reviewList: ReviewsModel)
    func showErrorReviews()
}

protocol ReviewsPresenterToRouterProtocol: AnyObject { // Any Router
    
    static func createReviewsModule(movieID: Int)-> ReviewsViewController
}

protocol ReviewsPresenterToInteractorProtocol: AnyObject { // Any Interactor
    var presenter: ReviewsInteractorToPresenterProtocol? { get set }

    func fetchReviewsByMovieID(movieID: Int, page: Int)
}

protocol ReviewsInteractorToPresenterProtocol: AnyObject {
    func reviewsFetchedSuccess(reviewListModelData: ReviewsModel)
    func reviewsFetchFailed()
}


