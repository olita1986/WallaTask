import Combine
import Foundation
import UIKit

final class ListHeroesView: UIView {
    // MARK: - Private Constants

    private enum Constant {
        static let estimatedRowHeight: CGFloat = 120
    }
    
    // MARK: - Public Properties

    let heroesTableView: UITableView = {
        let tableView = UITableView()
        tableView.accessibilityIdentifier = AccessibilityIdentifiers.HeroList.heroeTableView
        tableView.register(ListHeroesTableViewCell.self, forCellReuseIdentifier: "ListHeroesTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constant.estimatedRowHeight
        return tableView
    }()
    
    var refreshPublisher: AnyPublisher<Void, Never> {
        refreshSubject.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private let refreshControl = UIRefreshControl()
    private let refreshSubject = PassthroughSubject<Void, Never>()

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func stopRefreshing() {
        refreshControl.endRefreshing()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        heroesTableView.refreshControl = refreshControl
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        addSubviews()
        addContraints()
    }
    
    private func addSubviews() {
        addSubview(heroesTableView)
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            heroesTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            heroesTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heroesTableView.topAnchor.constraint(equalTo: topAnchor),
            heroesTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc
    private func refresh() {
        refreshSubject.send()
    }
}
