//
//  MovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 05/08/23.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    let movieImageView: UIImageView = {
        let movieImage = UIImageView()
        movieImage.contentMode = .scaleAspectFill
        return movieImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieImageView.frame = contentView.bounds
    }
    
    func setupUI(){
        contentView.backgroundColor = .black
        contentView.addSubview(movieImageView)
    }
    
    func setData(posterPath: String) {
        guard let movieImageURL = URL(string: "\(baseImageURL)\(posterPath)") else { return }
        movieImageView.sd_imageIndicator = SDWebImageActivityIndicator()
        movieImageView.sd_setImage(with: movieImageURL)
    }
}
