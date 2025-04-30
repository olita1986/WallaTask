import Foundation

protocol ListHeroesPresenterProtocol: AnyObject {
    var ui: ListHeroesUI? { get set }
    func screenTitle() -> String
    func getHeroes()
    func showHeroDetail(forHero hero: CharacterDataModel)
}

protocol ListHeroesUI: AnyObject {
    func update(heroes: [CharacterDataModel])
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
    // MARK: - Navigation

    var showHeroDetail: ((CharacterDataModel) -> Void)?
    
    var ui: ListHeroesUI?
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    
    init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
        self.getHeroesUseCase = getHeroesUseCase
    }
    
    func screenTitle() -> String {
        "List of Heroes"
    }
    
    // MARK: UseCases
    
    func getHeroes() {
        Task {
            do {
                let characterDataContainer = try await getHeroesUseCase.execute()
                self.ui?.update(heroes: characterDataContainer.characters)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Public Properties

    func showHeroDetail(forHero hero: CharacterDataModel) {
        showHeroDetail?(hero)
    }
}

