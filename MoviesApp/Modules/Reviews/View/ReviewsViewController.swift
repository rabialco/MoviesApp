//
//  ReviewsViewController.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 05/08/23.
//

import UIKit
import SnapKit
import Foundation
import UIScrollView_InfiniteScroll

class ReviewsViewController: UIViewController {
    
    var presenter: ReviewsViewToPresenterProtocol?

    var reviewList : [Review] = []
    
    var isContentExpand: Bool = false
    
    var selectedSection: Int = -1
    
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
        label.text = "All Reviews"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "ReviewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private lazy var emptyLabel : UILabel = {
        let label = UILabel()
        label.text = "- No Reviews -"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.startFetchingReviews(page: page)
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = view.bounds
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
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
            make.top.equalTo(titlePage.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalToSuperview().inset(25)
        }
        
        mainStackView.addSubview(emptyLabel)
        
        // MARK: - Empty Label
        // emptyLabel
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(titlePage.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        setupTableViewInfiniteScroll()
    }
    
    func setupTableViewInfiniteScroll(){
        tableView.infiniteScrollDirection = .vertical
        let frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        tableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: frame)
        tableView.addInfiniteScroll { [weak self] tableView in
            self?.page = self!.page + 1
            self?.presenter?.startFetchingReviews(page: self!.page)
            
            // FINISH
            tableView.finishInfiniteScroll()
        }
    }
    
}

extension ReviewsViewController: ReviewsPresenterToViewProtocol{

    func showReviews(reviewList: ReviewsModel) {
        
        self.reviewList.append(contentsOf: reviewList.results ?? [])
        if self.reviewList.count == 0 {
            self.emptyLabel.isHidden = false
        }
        else{
            self.emptyLabel.isHidden = true
        }
        self.tableView.reloadData()
        self.loadingView.stopAnimating()
        self.loadingView.isHidden = true
        
    }
    
    func showErrorReviews() {
        
        self.loadingView.stopAnimating()
        self.loadingView.isHidden = true
        let alert = UIAlertController(title: "Alert", message: "Problem Fetching Reviews", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return reviewList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.setData(review: reviewList[indexPath.section])
        
        if isContentExpand {
            cell.contentLabel.numberOfLines = 0
            cell.toggleContentButton.setTitle("Click to close review", for: .normal)
        } else {
            cell.contentLabel.numberOfLines = 6
            cell.toggleContentButton.setTitle("Click to read more", for: .normal)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedSection == indexPath.section && isContentExpand {
            return UITableView.automaticDimension
        } else {
            return 300
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedSection = indexPath.section
        isContentExpand = !isContentExpand
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}



