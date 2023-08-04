//
//  GenresRouter.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation
import UIKit

class GenresRouter: GenresPresenterToRouterProtocol{
    
    static func createModule() -> GenresViewController {
        let view = GenresViewController()
                
        let presenter: GenresViewToPresenterProtocol & GenresInteractorToPresenterProtocol = GenresPresenter()
        let interactor: GenresPresenterToInteractorProtocol = GenresInteractor()
        let router: GenresPresenterToRouterProtocol = GenresRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func pushToMoviesScreen(navigationConroller navigationController: UINavigationController, selectedGenre: Genre) {
        print("selectedGenre in GenreRouter : \(selectedGenre)")
        let moviesModule = MoviesRouter.createModule(selectedGenre: selectedGenre)
        navigationController.pushViewController(moviesModule, animated: true)
    }
    
}
