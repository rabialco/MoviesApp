//
//  ReviewCell.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 04/08/23.
//

import Foundation
import SnapKit
import SDWebImage

class ReviewCell : UITableViewCell {
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    private lazy var headerStackView : UIStackView = {
        let headerStackView = UIStackView()
        headerStackView.axis = .vertical
        headerStackView.spacing = 12
        return headerStackView
    }()
    
    let avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.masksToBounds = false
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.frame.size.height = 50
        avatarImageView.frame.size.width = 50
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()
    
    private lazy var createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .gray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white
        label.backgroundColor = .black
        label.numberOfLines = 6
        return label
    }()
    
    lazy var toggleContentButton: UIButton = {
        let toggleContentButton = UIButton()
        toggleContentButton.accessibilityIdentifier = "toggleContentButton"
        toggleContentButton.setTitle("Click to read more", for: .normal)
        toggleContentButton.setTitleColor(.white, for: .normal)
        toggleContentButton.contentHorizontalAlignment = .center
        toggleContentButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        toggleContentButton.backgroundColor = .black
        return toggleContentButton
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .black
        self.selectionStyle = .none
        self.accessoryType = .none
        self.isUserInteractionEnabled = true
        
        self.addSubview(avatarImageView)
        self.addSubview(headerStackView)
        
        // MARK: - Header Stack View
        // headerStackView
        headerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(70)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(15)
        }
        
        // MARK: - Avatar Image View
        // avatarImageView
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.leading.equalToSuperview().offset(20)
        }
        
        headerStackView.addSubview(authorLabel)
        
        // MARK: - Author Label
        // authorLabel
        authorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
        
        headerStackView.addSubview(createdAtLabel)
        
        // MARK: - Created At Label
        // createdAtLabel
        createdAtLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
        }
        
        headerStackView.addSubview(ratingLabel)
        
        // MARK: - Rating Label
        // ratingLabel
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(createdAtLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
            make.height.equalTo(30)
        }
        
        self.addSubview(contentLabel)
        
        // MARK: - Content Label
        // contentLabel
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.addSubview(toggleContentButton)
                
        // MARK: - Toggle Content Button
        // toggleContentButton
        toggleContentButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setData(review: Review) {
        guard let rating = review.authorDetails?.rating, let author = review.author, let createdAt = review.createdAt, let content = review.content else { return }
        self.ratingLabel.text = "Rating: \(rating)"
        self.authorLabel.text = "\(author)"
        self.createdAtLabel.text = "\(createdAt.components(separatedBy: "T")[0])"
        self.contentLabel.text = "\(content)"
        if (review.authorDetails?.avatarPath) == nil {
            self.avatarImageView.image = UIImage(systemName: "person.fill")
        }
        else {
            guard let avatarPath = review.authorDetails?.avatarPath else { return }
            guard let avatarImageURL = URL(string: "\(baseImageURL)\(avatarPath)") else { return }
            self.avatarImageView.sd_imageIndicator = SDWebImageActivityIndicator()
            self.avatarImageView.sd_setImage(with: avatarImageURL)
        }
    }
}

