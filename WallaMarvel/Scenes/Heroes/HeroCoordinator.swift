//
//  HeroCoordinator.swift
//  WallaMarvel
//
//  Created by orlando arzola on 30-04-25.
//

import Foundation

final class HeroCoordinator: BaseCoordinator {
    override func start() {
        let presenter = ListHeroesPresenter()
        presenter.showHeroDetail = { [weak self] hero in
            self?.showHeroDetail(forHero: hero)
        }
        let listHeroesViewController = ListHeroesViewController(presenter: presenter)
        listHeroesViewController.title = "Hero List"
        navigationController.pushViewController(listHeroesViewController, animated: false)
    }
    
    private func showHeroDetail(forHero hero: CharacterDataModel) {
        let heroDetailPresenter = HeroDetailPresenter(hero: hero)
        let heroDetailViewController = HeroDetailViewController(presenter: heroDetailPresenter)
        heroDetailViewController.title = hero.name
        navigationController.pushViewController(heroDetailViewController, animated: true)
    }
}
