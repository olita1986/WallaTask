import Foundation

protocol ListHeroesPresenterProtocol: AnyObject {
    var ui: ListHeroesUI? { get set }
    func screenTitle() -> String
    func getHeroes(initialHeroes: Bool)
    func showHeroDetail(forHero hero: CharacterDataModel)
    func setupSearchMode(isSearching: Bool)
}

protocol ListHeroesUI: AnyObject {
    func showPaginationLoading()
    func hidePaginationLoading()
    func showError(_ error: String)
    func showErrorPagination(_ error: String)
    func update(heroes: [CharacterDataModel])
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
    
    // MARK: - Pagination
    private var currentOffset = 0
    private let limit = 15
    private var isFetching = false
    private var heroes = [CharacterDataModel]()
    private var hasMoreHeroes = true

    // MARK: - Navigation

    var showHeroDetail: ((CharacterDataModel) -> Void)?
    
    // MARK: - View

    weak var ui: ListHeroesUI?
    
    // MARK: - Private Properties

    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    private var isSearching = false
    
    init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
        self.getHeroesUseCase = getHeroesUseCase
    }
    
    func screenTitle() -> String {
        "List of Heroes"
    }
    
    // MARK: UseCases
    
    func getHeroes(initialHeroes: Bool) {
        // If we are fetching initial heroes then we reset offset and hasMoreHeroes
        if initialHeroes {
            currentOffset = 0
            hasMoreHeroes = true
        }
        
        // If there is no more heroes to load show a message
        guard hasMoreHeroes else {
            ui?.showErrorPagination("There is no more heroes to load")
            return
        }

        // Avoid extra calls if it's fetching, and isSearching
        guard !isFetching, !isSearching else { return }
        isFetching = true
        ui?.showPaginationLoading()
        Task {
            do {
                // Get data
                let characterDataContainer = try await getHeroesUseCase.execute(offset: currentOffset, limit: limit)
                // Increase the offset
                currentOffset += characterDataContainer.count
                // Check if there is more heroes to load
                hasMoreHeroes = currentOffset < characterDataContainer.total
                // If it's initial load then replace the entire heroes else append then
                if initialHeroes {
                    heroes = characterDataContainer.characters
                } else {
                    heroes += characterDataContainer.characters
                }

                await MainActor.run {
                    isFetching = false
                    ui?.hidePaginationLoading()
                    ui?.update(heroes: heroes)
                }
            } catch {
                await MainActor.run {
                    isFetching = false
                    ui?.hidePaginationLoading()
                    if initialHeroes {
                        ui?.showError(error.localizedDescription)
                    } else {
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

