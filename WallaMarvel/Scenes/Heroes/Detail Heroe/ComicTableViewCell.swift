//
//  ComicTableViewCell.swift
//  WallaMarvel
//
//  Created by orlando arzola on 01-05-25.
//

import Kingfisher
import UIKit

class ComicTableViewCell: UITableViewCell {

    private let comicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()

    private let comicTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let comicDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let comicSeriesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withComic comic: ComicDataModel) {
        comicTitleLabel.text = comic.title
        comicDescriptionLabel.text = comic.description.isEmpty ? "Description: NA" : "Description: \(comic.description)"
        comicSeriesLabel.text = comic.series.name.isEmpty ? "Description: NA" : "Series: \(comic.series.name)"
        comicImageView.kf.setImage(with: comic.thumbnail.url)
    }
    
    private func setupView() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(comicImageView)
        mainStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(comicTitleLabel)
        infoStackView.addArrangedSubview(comicDescriptionLabel)
        infoStackView.addArrangedSubview(comicSeriesLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
