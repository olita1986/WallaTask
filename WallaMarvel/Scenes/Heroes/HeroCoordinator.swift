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
        let listHeroesViewController = ListHeroesViewController()
        listHeroesViewController.presenter = presenter
        listHeroesViewController.title = "Hero List"
        navigationController.pushViewController(listHeroesViewController, animated: false)
    }
}
