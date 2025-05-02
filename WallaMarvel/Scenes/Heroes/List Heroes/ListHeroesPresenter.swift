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
        
        // Avoid extra calls if it's fetching, has no more heroes and isSearching
        guard !isFetching, hasMoreHeroes, !isSearching else { return }
        isFetching = true
        ui?.showPaginationLoading()
        Task {
            do {
                let characterDataContainer = try await getHeroesUseCase.execute(offset: currentOffset, limit: limit)
                currentOffset += characterDataContainer.count
                hasMoreHeroes = currentOffset < characterDataContainer.total
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
                isFetching = false
                ui?.hidePaginationLoading()
                print(error.localizedDescription)
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

