//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 04/08/23.
//

import Foundation
import UIKit
import SnapKit
import WebKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    
    var presenter: MovieDetailViewToPresenterProtocol?

    var movieDetail : MovieDetailModel?
    var trailedID : String = ""

    private lazy var mainStackView : UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        return mainStackView
    }()
    
    private lazy var headerStackView : UIStackView = {
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
    
    private lazy var loadingVideoPlayerView: UIActivityIndicatorView = {
        let loadingVideoPlayerView = UIActivityIndicatorView()
        loadingVideoPlayerView.color = UIColor.white
        loadingVideoPlayerView.isHidden = true
        return loadingVideoPlayerView
    }()
    
    private let videoPlayerView: UIView = {
        let videoPlayerView = UIView()
        videoPlayerView.backgroundColor = .gray
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerView.layer.cornerRadius = 10
        return videoPlayerView
    }()
    
    private lazy var videoPlayer: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = .audio
        let videoPlayer = WKWebView(frame: .zero, configuration: config)
        videoPlayer.isHidden = true
        videoPlayer.navigationDelegate = self
        videoPlayer.layer.masksToBounds = true
        videoPlayer.layer.cornerRadius = 10
        return videoPlayer
    }()
    
    private lazy var movieImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.sd_imageIndicator = SDWebImageActivityIndicator()
        return image
    }()
    
    private lazy var movieTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .gray
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .gray
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Movie Overview"
        return label
    }()
    
    private lazy var overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 18, weight: .regular)
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        textView.textAlignment = .justified
        textView.isEditable = false
        textView.backgroundColor = .black
        return textView
    }()
    
    private lazy var seeReviewsButton: UIButton = {
        let seeReviewsButton = UIButton()
        seeReviewsButton.accessibilityIdentifier = "seeReviewsButton"
        seeReviewsButton.setTitle("See Reviews", for: .normal)
        seeReviewsButton.setTitleColor(.white, for: .normal)
        seeReviewsButton.contentHorizontalAlignment = .center
        seeReviewsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        seeReviewsButton.backgroundColor = .black
        seeReviewsButton.layer.borderWidth = 1
        seeReviewsButton.layer.borderColor = UIColor.white.cgColor
        seeReviewsButton.layer.cornerRadius = 10
        seeReviewsButton.addTarget(self, action: #selector(self.clickOnSeeReviews(_:)), for: .touchUpInside)
        return seeReviewsButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.startFetchingMovieDetail()
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        
        presenter?.startFetchingYoutubeTrailer()
        self.loadingVideoPlayerView.startAnimating()
        self.loadingVideoPlayerView.isHidden = false
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPlayer.frame = videoPlayerView.bounds
        loadingVideoPlayerView.frame = videoPlayerView.frame
    }
    
    func setupUI() {
        self.title = "Movie Detail"
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
        
        mainStackView.addSubview(videoPlayerView)
        
        // MARK: - Video Player View
        // videoPlayerView
        videoPlayerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(200)
        }
        
        videoPlayerView.addSubview(loadingVideoPlayerView)
        videoPlayerView.addSubview(videoPlayer)
        
        // MARK: - Loading Video Player View
        // loadingVideoPlayerView
        loadingVideoPlayerView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerX.centerY.equalToSuperview()
        }
        
        mainStackView.addSubview(movieImageView)
        
        // MARK: - Movie Image View
        // movieImageView
        movieImageView.snp.makeConstraints { make in
            make.top.equalTo(videoPlayerView.snp.bottom).offset(25)
            make.height.equalTo(150)
            make.width.equalTo(100)
            make.leading.equalToSuperview().offset(10)
        }
        
        mainStackView.addSubview(headerStackView)
        
        // MARK: - Header Stack View
        // headerStackView
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(videoPlayerView.snp.bottom).offset(25)
            make.height.equalTo(150)
            make.leading.equalTo(movieImageView.snp.trailing).offset(15)
            make.trailing.equalTo(videoPlayerView.snp.trailing)
        }
        
        headerStackView.addSubview(movieTitle)
        
        // MARK: - MovieTitle
        // movieTitle
        movieTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.width.equalToSuperview()
        }
        
        headerStackView.addSubview(genreLabel)
        
        // MARK: - Genre Label
        // genreLabel
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        headerStackView.addSubview(releaseDateLabel)
        
        // MARK: - Release Date Label
        // releaseDateLabel
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(5)
        }
        
        mainStackView.addSubview(overviewLabel)
        
        // MARK: - Overview Label
        // overviewLabel
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(20)
            make.leading.equalTo(videoPlayerView.snp.leading).offset(10)
            make.height.equalTo(30)
        }
        
        mainStackView.addSubview(seeReviewsButton)
        
        // MARK: - See Reviews Button
        // seeReviewsButton
        seeReviewsButton.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(20)
            make.trailing.equalTo(videoPlayerView.snp.trailing).offset(-5)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        mainStackView.addSubview(overviewTextView)

        // MARK: - Overview Text View
        // overviewTextView
        overviewTextView.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(10)
            make.leading.equalTo(videoPlayerView.snp.leading)
            make.trailing.equalTo(videoPlayerView.snp.trailing).offset(-5)
        }

    }
    
    @objc func clickOnSeeReviews(_ sender: UIButton) {
        presenter?.showReviewsController(navigationController: navigationController!, movieID: self.movieDetail?.id ?? 0)
    }
}

extension MovieDetailViewController: MovieDetailPresenterToViewProtocol{

    func showMovieDetail(movieDetailData: MovieDetailModel) {

        self.movieDetail = movieDetailData
        self.movieTitle.text = movieDetailData.title ?? movieDetailData.originalTitle ?? ""
        guard let movieImageURL = URL(string: "\(baseImageURL)\(movieDetailData.posterPath!)") else { return }
        self.movieImageView.sd_imageIndicator = SDWebImageActivityIndicator()
        self.movieImageView.sd_setImage(with: movieImageURL)
        
        var genreArray : [String] = []
        for genres in movieDetailData.genres!{
            genreArray.append(genres.name)
        }
        self.genreLabel.text = genreArray.joined(separator: ", ")
        
        self.releaseDateLabel.text = "Release Date : \(movieDetailData.releaseDate ?? "-")"
        
        self.overviewTextView.text = movieDetailData.overview != "" ? movieDetailData.overview : "-"
        self.loadingView.stopAnimating()
        self.loadingView.isHidden = true
    }
    
    func showYoutubeTrailer(videoID: String) {
        self.trailedID = videoID
        print("VIDEO ID : \(videoID)")
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return }
        videoPlayer.load(URLRequest(url: youtubeURL))
        
    }
    
    func showErrorMovieDetail() {
        
        self.loadingView.stopAnimating()
        self.loadingView.isHidden = true
        let alert = UIAlertController(title: "Alert", message: "Problem Fetching Movie Detail", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showErrorYoutubeTrailer() {
        
        self.loadingVideoPlayerView.stopAnimating()
        self.loadingVideoPlayerView.isHidden = true
        let alert = UIAlertController(title: "Alert", message: "Problem Fetching Youtube Trailer", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}

extension MovieDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingVideoPlayerView.stopAnimating()
        loadingVideoPlayerView.isHidden = true
        webView.isHidden = false
    }
}
