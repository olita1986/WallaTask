import UIKit

final class ListHeroesViewController: UIViewController {
    var mainView: ListHeroesView { return view as! ListHeroesView  }
    
    var presenter: ListHeroesPresenterProtocol?
    var listHeroesProvider: ListHeroesAdapter?
    
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
        listHeroesProvider?.heroes = heroes
    }
}

extension ListHeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let hero = listHeroesProvider?.heroes[indexPath.row] else { return }
        presenter?.showHeroDetail(forHero: hero)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let heroCount = listHeroesProvider?.heroes.count,
              indexPath.row == heroCount - 2 else { return }
        
        presenter?.getHeroes(initialHeroes: false)
    }
}

