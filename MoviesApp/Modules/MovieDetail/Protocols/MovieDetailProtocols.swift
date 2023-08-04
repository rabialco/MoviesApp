//
//  MovieDetailProtocols.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 04/08/23.
//

import Foundation
import UIKit

protocol MovieDetailViewToPresenterProtocol: AnyObject{ // Any Presenter
    
    var view: MovieDetailPresenterToViewProtocol? { get set }
    var interactor: MovieDetailPresenterToInteractorProtocol? { get set }
    var router: MovieDetailPresenterToRouterProtocol? { get set }
    var selectedMovie: Movie? { get set }
    
    func startFetchingMovieDetail()
    func startFetchingYoutubeTrailer()
    func showReviewsController(navigationController: UINavigationController, movieID: Int)

}

protocol MovieDetailPresenterToViewProtocol: AnyObject { // Any View
    var presenter: MovieDetailViewToPresenterProtocol? { get set }
    
    func showMovieDetail(movieDetailData: MovieDetailModel)
    func showYoutubeTrailer(videoID: String)
    func showErrorMovieDetail()
    func showErrorYoutubeTrailer()
}

protocol MovieDetailPresenterToRouterProtocol: AnyObject { // Any Router
    
    static func createMovieModule(selectedMovie: Movie)-> MovieDetailViewController
    func pushToReviewsScreen(navigationConroller: UINavigationController, movieID: Int)
}

protocol MovieDetailPresenterToInteractorProtocol: AnyObject { // Any Interactor
    var presenter: MovieDetailInteractorToPresenterProtocol? { get set }
    func fetchMovieDetailByID(movieID: Int)
    func fetchYoutubeTrailerByTitle(title: String)
}

protocol MovieDetailInteractorToPresenterProtocol: AnyObject {
    func movieDetailFetchedSuccess(movieDetailModelData: MovieDetailModel)
    func movieDetailFetchFailed()
    func youtubeTrailerFetchedSuccess(videoID: String)
    func youtubeTrailerFetchFailed()
}

