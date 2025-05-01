//
//  HeroDetailPresenter.swift
//  WallaMarvel
//
//  Created by orlando arzola on 01-05-25.
//

import Foundation

protocol HeroDetailPresenterProtocol: AnyObject {
    var ui: ComicsUI? { get set }
    func heroInfo() -> CharacterDataModel
    func getComics()
}

protocol ComicsUI: AnyObject {
    func update(comics: [ComicDataModel])
}
final class HeroDetailPresenter: HeroDetailPresenterProtocol {
    weak var ui: ComicsUI?
    private let hero: CharacterDataModel
    private let getComicsUseCase: GetComicsUseCaseProtocol
    
    init(hero: CharacterDataModel,
         getComicsUseCase: GetComicsUseCaseProtocol = GetComics()) {
        self.hero = hero
        self.getComicsUseCase = getComicsUseCase
    }

    func heroInfo() -> CharacterDataModel {
        return hero
    }
    
    func getComics() {
        Task {
            do {
                let comicsContainer = try await getComicsUseCase.execute(forHeroId: hero.id)
                await MainActor.run {
                    self.ui?.update(comics: comicsContainer.comics)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
