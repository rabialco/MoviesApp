//
//  ReviewsInteractor.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 05/08/23.
//

import Foundation
import Moya

class ReviewsInteractor: ReviewsPresenterToInteractorProtocol{
    
    var presenter: ReviewsInteractorToPresenterProtocol?
    
    func fetchReviewsByMovieID(movieID: Int, page: Int) {
        apiManager.request(.getReviewsByMovieID(movieID: movieID, page: page)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data // Data, your JSON response is probably in here!
                let _ = moyaResponse.statusCode // Int - 200, 401, 500, etc

                do {
                    let reviewListDecoded = try JSONDecoder().decode(ReviewsModel.self, from: data)
                    self.presenter?.reviewsFetchedSuccess(reviewListModelData: reviewListDecoded)
                }
                catch {
                    print("==================================")
                    print("Error JSONSerialization : \(error.localizedDescription)")
                    print("==================================\n")
                    self.presenter?.reviewsFetchFailed()
                }
            case let .failure(error):
                // TODO: handle the error == best. comment. ever.
                print("==================================")
                print("Error Fetch Reviews : \(error.localizedDescription)")
                print("==================================\n")
                self.presenter?.reviewsFetchFailed()
            }
        }
    }
}


