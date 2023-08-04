//
//  GenresProtocol.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation
import UIKit

protocol GenresViewToPresenterProtocol: AnyObject{ // Any Presenter
    
    var view: GenresPresenterToViewProtocol? { get set }
    var interactor: GenresPresenterToInteractorProtocol? { get set }
    var router: GenresPresenterToRouterProtocol? { get set }
    
    func startFetchingGenres()
    func showMoviesController(navigationController: UINavigationController, selectedGenre: Genre)

}

protocol GenresPresenterToViewProtocol: AnyObject { // Any View
    
    func showGenres(genresArray: GenresModel)
    func showError()
}

protocol GenresPresenterToRouterProtocol: AnyObject { // Any Router
    
    static func createModule()-> GenresViewController
    func pushToMoviesScreen(navigationConroller:UINavigationController, selectedGenre: Genre)
}

protocol GenresPresenterToInteractorProtocol: AnyObject { // Any Interactor
    var presenter: GenresInteractorToPresenterProtocol? { get set }
    func fetchGenres()
}

protocol GenresInteractorToPresenterProtocol: AnyObject {
    func genresFetchedSuccess(genresModelArray: GenresModel)
    func genresFetchFailed()
}
