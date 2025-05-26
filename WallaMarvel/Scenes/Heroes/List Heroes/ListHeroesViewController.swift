import Combine
import UIKit

final class ListHeroesViewController: UIViewController {
    // MARK: - Components

    private var mainView: ListHeroesView { return view as! ListHeroesView  }
    
    // MARK: - Private Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var cancellables = Set<AnyCancellable>()
    private let presenter: ListHeroesPresenterProtocol
    private var listHeroesProvider: ListHeroesProvider?

    override func loadView() {
        view = ListHeroesView()
    }

    init(presenter: ListHeroesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listHeroesProvider = ListHeroesProvider(tableView: mainView.heroesTableView)
        presenter.ui = self
        presenter.getHeroes(initialHeroes: true, forceRefresh: false)
        
        title = presenter.screenTitle()
        
        mainView.heroesTableView.delegate = self
        setupSearchController()
        setupBindings()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Heroes"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupBindings() {
        mainView.refreshPublisher
            .sink { [weak self] in
                self?.presenter.getHeroes(initialHeroes: false, forceRefresh: true)
            }
            .store(in: &cancellables)
    }
}

extension ListHeroesViewController: ListHeroesUI {
    func updateFromSearch(heroes: [CharacterDataModel]) {
        listHeroesProvider?.updateFoundHeroes(heroes: heroes)
    }

    func resetResults() {
        listHeroesProvider?.resetFilter()
    }

    func showInitialLoading() {
        mainView.heroesTableView.showLoading(loadingText: "Loading Heroes")
    }
    
    func hideInitialLoading() {
        mainView.heroesTableView.hideLoading()
    }

    func showPaginationLoading() {
        mainView.heroesTableView.showPaginationLoading()
    }

    func hidePaginationLoading() {
        mainView.heroesTableView.tableFooterView = nil
    }

    func update(heroes: [CharacterDataModel]) {
        mainView.stopRefreshing()
        listHeroesProvider?.heroes = heroes
    }
    
    func showError(_ error: String) {
        self.showAlert(message: error)
    }
    
    func showErrorPagination(_ error: String) {
        mainView.heroesTableView.showPaginationError(message: error) { [weak self] in
            self?.presenter.getHeroes(initialHeroes: false, forceRefresh: false)
        }
    }
}

extension ListHeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let hero = listHeroesProvider?.filteredHeroes[indexPath.row] else { return }
        presenter.showHeroDetail(forHero: hero)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let heroCount = listHeroesProvider?.heroes.count,
              indexPath.row == heroCount - 2 else { return }
        
        presenter.getHeroes(initialHeroes: false, forceRefresh: false)
    }
}

extension ListHeroesViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        presenter.searchHero(withText: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        presenter.setupSearchMode(isSearching: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        presenter.setupSearchMode(isSearching: false)
    }
}
