//
//  MovieDetailPresenter.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 04/08/23.
//

import Foundation
import UIKit

class MovieDetailPresenter: MovieDetailViewToPresenterProtocol {
    
    var selectedMovie: Movie?
    
    var router: MovieDetailPresenterToRouterProtocol?
    
    var interactor: MovieDetailPresenterToInteractorProtocol?
    
    var view: MovieDetailPresenterToViewProtocol?
    
    func startFetchingMovieDetail() {
        interactor?.fetchMovieDetailByID(movieID: selectedMovie!.id ?? 0)
    }
    func startFetchingYoutubeTrailer() {
        interactor?.fetchYoutubeTrailerByTitle(title: selectedMovie?.title ?? selectedMovie?.originalTitle ?? "")
    }
    
    func showReviewsController(navigationController: UINavigationController, movieID: Int) {
        router?.pushToReviewsScreen(navigationConroller: navigationController, movieID: selectedMovie?.id ?? 0)
    }

}

extension MovieDetailPresenter: MovieDetailInteractorToPresenterProtocol{
    
    func movieDetailFetchedSuccess(movieDetailModelData: MovieDetailModel) {
        view?.showMovieDetail(movieDetailData: movieDetailModelData)
    }
    
    func movieDetailFetchFailed() {
        view?.showErrorMovieDetail()
    }
    
    func youtubeTrailerFetchedSuccess(videoID: String) {
        view?.showYoutubeTrailer(videoID: videoID)
    }
    
    func youtubeTrailerFetchFailed() {
        view?.showErrorYoutubeTrailer()
    }
    
}


