import Combine
import UIKit

final class ListHeroesViewController: UIViewController {
    // MARK: - Public Properties

    var mainView: ListHeroesView { return view as! ListHeroesView  }
    
    var presenter: ListHeroesPresenterProtocol?
    var listHeroesProvider: ListHeroesAdapter?
    
    // MARK: - Private Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = ListHeroesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listHeroesProvider = ListHeroesAdapter(tableView: mainView.heroesTableView)
        presenter?.getHeroes(initialHeroes: true)
        presenter?.ui = self
        
        title = presenter?.screenTitle()
        
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
                self?.presenter?.getHeroes(initialHeroes: true)
            }
            .store(in: &cancellables)
    }
}

extension ListHeroesViewController: ListHeroesUI {
    func showPaginationLoading() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: mainView.heroesTableView.bounds.width, height: 44)
        mainView.heroesTableView.tableFooterView = spinner
    }

    func hidePaginationLoading() {
        mainView.heroesTableView.tableFooterView = nil
    }

    func update(heroes: [CharacterDataModel]) {
        mainView.stopRefreshing()
        listHeroesProvider?.heroes = heroes
    }
}

extension ListHeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let hero = listHeroesProvider?.filteredHeroes[indexPath.row] else { return }
        presenter?.showHeroDetail(forHero: hero)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let heroCount = listHeroesProvider?.heroes.count,
              indexPath.row == heroCount - 2 else { return }
        
        presenter?.getHeroes(initialHeroes: false)
    }
}

extension ListHeroesViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            listHeroesProvider?.resetFilter()
        } else {
            listHeroesProvider?.searchHeroe(withText: searchText)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        presenter?.setupSearchMode(isSearching: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        presenter?.setupSearchMode(isSearching: false)
    }
}
