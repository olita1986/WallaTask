import Foundation
import UIKit
import Kingfisher

final class ListHeroesTableViewCell: UITableViewCell {
    private let heroeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let heroeName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubviews()
        addContraints()
    }
    
    private func addSubviews() {
        mainStackView.addArrangedSubview(heroeImageView)
        mainStackView.addArrangedSubview(heroeName)
        contentView.addSubview(mainStackView)
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            heroeImageView.heightAnchor.constraint(equalToConstant: 80),
            heroeImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configure(model: CharacterDataModel) {
        heroeImageView.kf.setImage(with: model.thumbnail.url)
        heroeName.text = model.name
    }
}
