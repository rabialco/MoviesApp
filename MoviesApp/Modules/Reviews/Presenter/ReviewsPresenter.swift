//
//  ReviewsPresenter.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 05/08/23.
//

import Foundation
import UIKit

class ReviewsPresenter: ReviewsViewToPresenterProtocol {
    
    var movieID: Int?
    
    var router: ReviewsPresenterToRouterProtocol?
    
    var interactor: ReviewsPresenterToInteractorProtocol?
    
    var view: ReviewsPresenterToViewProtocol?
    
    func startFetchingReviews(page: Int){
        interactor?.fetchReviewsByMovieID(movieID: movieID ?? 0, page: page)
    }

}

extension ReviewsPresenter: ReviewsInteractorToPresenterProtocol{
    
    func reviewsFetchedSuccess(reviewListModelData: ReviewsModel) {
        view?.showReviews(reviewList: reviewListModelData)
    }
    
    func reviewsFetchFailed() {
        view?.showErrorReviews()
    }
    
}



