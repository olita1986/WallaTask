//
//  HeroDetailViewController.swift
//  WallaMarvel
//
//  Created by orlando arzola on 30-04-25.
//

import UIKit

class HeroDetailViewController: UIViewController {

    var presenter: HeroDetailPresenterProtocol?

    // MARK: - Components
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    private let heroeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return imageView
    }()
    
    private let heroeNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        getInfo()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        headerStackView.addArrangedSubview(heroeImageView)
        headerStackView.addArrangedSubview(heroeNameLabel)
        mainStackView.addArrangedSubview(headerStackView)
        mainStackView.addArrangedSubview(UIView())
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func getInfo() {
        guard let hero = presenter?.heroInfo() else { return }
        heroeImageView.kf.setImage(with: URL(string: hero.thumbnail.path + "/portrait_small." + hero.thumbnail.extension))
        heroeNameLabel.text = hero.name
    }
}
