//
//  GenresViewController.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import UIKit
import SnapKit
import Foundation

class GenresViewController: UIViewController {
    
    var presenter: GenresViewToPresenterProtocol?

    var genreList : [Genre] = []

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
        label.text = "List of Movie Genres"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.register(GenreCell.self, forCellReuseIdentifier: "GenreCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.startFetchingGenres()
        self.loadingView.isHidden = false
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
        mainStackView.addSubview(tableView)
        
        // MARK: - Title Page
        // titlePage
        titlePage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        // MARK: - Table View
        // tableView
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titlePage.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalToSuperview().inset(25)
        }
    }
    
    
}

extension GenresViewController: GenresPresenterToViewProtocol{

    func showGenres(genresArray: GenresModel) {

        self.genreList = genresArray.genres
        self.tableView.reloadData()
        self.loadingView.isHidden = true
        
    }
    
    func showError() {
        
        self.loadingView.isHidden = true
        let alert = UIAlertController(title: "Alert", message: "Problem Fetching Genres", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}

extension GenresViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as! GenreCell
        cell.setData(genre: genreList[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        cell.tintColor = .white

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showMoviesController(navigationController: navigationController!, selectedGenre: genreList[indexPath.row])
        print("selectedGenre in GenreVC : \(genreList[indexPath.row])")
    }
    
    
}


