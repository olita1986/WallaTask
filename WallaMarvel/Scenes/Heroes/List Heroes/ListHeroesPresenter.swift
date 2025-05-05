import Foundation

protocol ListHeroesPresenterProtocol: AnyObject {
    var ui: ListHeroesUI? { get set }
    func screenTitle() -> String
    func getHeroes(initialHeroes: Bool,  forceRefresh: Bool)
    func showHeroDetail(forHero hero: CharacterDataModel)
    func setupSearchMode(isSearching: Bool)
    func searchHero(withText text: String?)
}

protocol ListHeroesUI: AnyObject {
    func showInitialLoading()
    func hideInitialLoading()
    func showPaginationLoading()
    func hidePaginationLoading()
    func showError(_ error: String)
    func showErrorPagination(_ error: String)
    func update(heroes: [CharacterDataModel])
    func updateFromSearch(heroes: [CharacterDataModel])
    func resetResults()
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
    private var searchTask: Task<Void, Never>?
    
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
    
    func searchHero(withText text: String?) {
        // Trim all white spaces and lines
        let searchText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        // Check if there is text or if it is empty
        guard let searchText, !searchText.isEmpty else {
            // Else reset the results and cancel the task
            ui?.resetResults()
            searchTask?.cancel()
            return
        }

        // Cancel any previous task to avoid repeating calls
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                // Debounce the call for 0.5 seconds
                try await Task.sleep(nanoseconds: UInt64(0.5) * 1_000_000_000)
            } catch {
                return
            }
            
            // Check that the task is not being cancelled
            guard !Task.isCancelled else {
                return
            }

            do {
                // Make hero request
                let requestedHeroes = try await listHeroeHandler.getRequestedHeroes(withText: searchText)
                await MainActor.run {
                    // If the result is empty show an error
                    if requestedHeroes.isEmpty {
                        ui?.showError("No heroes found. Try with another query")
                    } else {
                        // Else show results
                        ui?.updateFromSearch(heroes: requestedHeroes)
                    }
                }
            } catch {
                // If error is not because of Task Cancellation then show error
                if !(error.localizedDescription == "cancelled") {
                    await MainActor.run {
                        ui?.showError(error.localizedDescription)
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
