//
//  GenreCell.swift
//  MoviesApp
//
//  Created by Rabialco Argana on 03/08/23.
//

import Foundation
import SnapKit

class GenreCell : UITableViewCell {
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        self.tintColor = .white
        self.backgroundColor = .black
        self.selectionStyle = .none
        self.accessoryType = .none
        
        // MARK: - STACK VIEW
        self.addSubview(mainStackView)
        
        // mainStackView
        mainStackView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.centerY.equalTo(self)
        }
        
        mainStackView.addSubview(nameLabel)
        
        // MARK: - Name Label
        // nameLabel
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
    }
    
    func setData(genre: Genre) {
        self.nameLabel.text = "\(genre.name)"
    }
}
