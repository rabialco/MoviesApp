//
//  MoviesViewController.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation
import UIKit
import SnapKit
import UIScrollView_InfiniteScroll

class MoviesViewController: UIViewController {
    
    var presenter: MoviesViewToPresenterProtocol?

    var movieList : [Movie] = []
    var page: Int = 1

    private lazy var mainStackView : UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        return mainStackView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.color = UIColor.white
        loadingView.isHidden = true
        return loadingView
    }()
    
    private lazy var titlePage : UILabel = {
        let label = UILabel()
        label.text = "List of Movies"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 30, height: 300)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.startFetchingMovies(page: page)
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .black
        view.addSubview(mainStackView)
        view.addSubview(loadingView)
        
        // MARK: - Main Stack View
        // mainStackView
        mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // MARK: - Loading View
        // loadingView
        loadingView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerX.centerY.equalToSuperview()
        }
        
        mainStackView.addSubview(titlePage)
        mainStackView.addSubview(collectionView)
        
        // MARK: - Title Page
        // titlePage
        titlePage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        // MARK: - Collection View
        // collectionView
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titlePage.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalToSuperview().inset(25)
        }
        setupCollectionViewInfiniteScroll()
    }
    
    func setupCollectionViewInfiniteScroll(){
        collectionView.infiniteScrollDirection = .vertical
        let frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        collectionView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: frame)
        collectionView.addInfiniteScroll { [weak self] tableView in
            self?.page = self!.page + 1
            self?.presenter?.startFetchingMovies(page: self!.page)
            
            // FINISH
            self?.collectionView.finishInfiniteScroll()
        }
    }
}

extension MoviesViewController: MoviesPresenterToViewProtocol{

    func showMovies(moviesArray: MoviesModel) {

        self.movieList.append(contentsOf: moviesArray.results ?? [])
        self.collectionView.reloadData()
        self.loadingView.stopAnimating()
        self.loadingView.isHidden = true
        
    }
    
    func showError() {
        
        self.loadingView.stopAnimating()
        self.loadingView.isHidden = true
        let alert = UIAlertController(title: "Alert", message: "Problem Fetching Movies by Genre", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setData(posterPath: movieList[indexPath.row].posterPath ?? "")
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter?.showMovieDetailController(navigationController: navigationController!, selectedMovie: movieList[indexPath.row])
    }
}
