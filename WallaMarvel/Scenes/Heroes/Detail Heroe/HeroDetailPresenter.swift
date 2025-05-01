//
//  HeroDetailPresenter.swift
//  WallaMarvel
//
//  Created by orlando arzola on 01-05-25.
//

import Foundation

protocol HeroDetailPresenterProtocol: AnyObject {
    func heroInfo() -> CharacterDataModel
}

final class HeroDetailPresenter: HeroDetailPresenterProtocol {
    private let hero: CharacterDataModel

    init(hero: CharacterDataModel) {
        self.hero = hero
    }

    func heroInfo() -> CharacterDataModel {
        return hero
    }
}
