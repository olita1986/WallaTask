//
//  HeroDetailViewController.swift
//  WallaMarvel
//
//  Created by orlando arzola on 30-04-25.
//

import Kingfisher
import UIKit

final class HeroDetailViewController: UIViewController {

    var presenter: HeroDetailPresenterProtocol?
    private var comics = [ComicDataModel]() {
        didSet {
            comicsTableView.reloadData()
        }
    }

    // MARK: - Components
    
    private lazy var comicSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Comics"
        label.accessibilityIdentifier = AccessibilityIdentifiers.HeroDetail.heroDetailComicLabel
        return label
    }()

    private lazy var comicsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ComicTableViewCell.self, forCellReuseIdentifier: "ComicTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.dataSource = self
        return tableView
    }()

    private lazy var comicSectionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var heroeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return imageView
    }()
    
    private lazy var heroeNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        getInfo()
        presenter?.ui = self
        presenter?.getComics()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        headerStackView.addArrangedSubview(heroeImageView)
        headerStackView.addArrangedSubview(heroeNameLabel)
        comicSectionStackView.addArrangedSubview(comicSectionTitleLabel)
        comicSectionStackView.addArrangedSubview(comicsTableView)
        mainStackView.addArrangedSubview(headerStackView)
        mainStackView.addArrangedSubview(comicSectionStackView)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func getInfo() {
        guard let hero = presenter?.heroInfo() else { return }
        heroeImageView.kf.setImage(with: hero.thumbnail.url)
        heroeNameLabel.text = hero.name
    }
}

extension HeroDetailViewController: ComicsUI {
    func showLoading() {
        comicsTableView.showLoading(loadingText: "Loading Comics")
    }
    
    func hideLoading() {
        comicsTableView.hideLoading()
    }
    
    func update(comics: [ComicDataModel]) {
        self.comics = comics
    }
}

extension HeroDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ComicTableViewCell", for: indexPath) as? ComicTableViewCell else { return UITableViewCell() }
    
        let comic = comics[indexPath.row]
        
        cell.configure(withComic: comic)
        
        return cell
    }
}
