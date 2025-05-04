import Foundation

protocol ListHeroesPresenterProtocol: AnyObject {
    var ui: ListHeroesUI? { get set }
    func screenTitle() -> String
    func getHeroes(initialHeroes: Bool,  forceRefresh: Bool)
    func showHeroDetail(forHero hero: CharacterDataModel)
    func setupSearchMode(isSearching: Bool)
}

protocol ListHeroesUI: AnyObject {
    func showInitialLoading()
    func hideInitialLoading()
    func showPaginationLoading()
    func hidePaginationLoading()
    func showError(_ error: String)
    func showErrorPagination(_ error: String)
    func update(heroes: [CharacterDataModel])
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
    // MARK: - Navigation

    var showHeroDetail: ((CharacterDataModel) -> Void)?
    
    // MARK: - View

    weak var ui: ListHeroesUI?
    
    // MARK: - Private Properties

    private let listHeroeHandler: ListHeroesHandlerProtocol
    private var isSearching = false
    private var isFetching = false
    
    init(listHeroeHandler: ListHeroesHandlerProtocol = ListHeroesHandler()) {
        self.listHeroeHandler = listHeroeHandler
    }
    
    func screenTitle() -> String {
        "List of Heroes"
    }
    
    // MARK: UseCases
    
    func getHeroes(initialHeroes: Bool, forceRefresh: Bool) {
        // Avoid extra calls if it's fetching, and isSearching
        guard !isFetching, !isSearching else { return }
        isFetching = true
        if initialHeroes || forceRefresh {
            ui?.showInitialLoading()
        } else {
            ui?.showPaginationLoading()
        }
        Task {
            do {
                // Get data
                let heroes = try await listHeroeHandler.getData(initialHeroes: initialHeroes,
                                                                forceRefresh: forceRefresh)

                await MainActor.run {
                    isFetching = false
                    ui?.hidePaginationLoading()
                    ui?.hideInitialLoading()
                    ui?.update(heroes: heroes)
                }
            } catch {
                await MainActor.run {
                    isFetching = false
                    if initialHeroes || forceRefresh {
                        ui?.hideInitialLoading()
                        ui?.showError(error.localizedDescription)
                    } else {
                        ui?.hidePaginationLoading()
                        ui?.showErrorPagination(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Public Methods

    func showHeroDetail(forHero hero: CharacterDataModel) {
        showHeroDetail?(hero)
    }
    
    func setupSearchMode(isSearching: Bool) {
        self.isSearching = isSearching
    }
}

