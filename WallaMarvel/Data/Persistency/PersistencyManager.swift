//
//  PersistencyManager.swift
//  WallaMarvel
//
//  Created by orlando arzola on 04-05-25.
//

import Foundation

protocol PersistencyManagerProtocol: AnyObject {
    func saveHeroesData(heroesData: PaginationModel)
    func loadHeroesData() -> PaginationModel?
    func clearCache()
}

final class PersistencyManager: PersistencyManagerProtocol {
    private enum Keys {
        static let heroesKey = "HeroesData"
    }
    private let userDefaults: UserDefaults
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveHeroesData(heroesData: PaginationModel) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(heroesData) {
            userDefaults.set(data, forKey: Keys.heroesKey)
        }
    }
    
    func loadHeroesData() -> PaginationModel? {
        guard let heroesData = userDefaults.data(forKey: Keys.heroesKey) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode(PaginationModel.self,
                                       from: heroesData)
    }
    
    func clearCache() {
        userDefaults.removeObject(forKey: Keys.heroesKey)
    }
}

struct PaginationModel: Codable, Equatable {
    let offset: Int
    let total: Int
    let hasMoreData: Bool
    let heroes: [CharacterDataModel]
    
    init(offset: Int,
         total: Int,
         hasMoreData: Bool,
         heroes: [CharacterDataModel]) {
        self.offset = offset
        self.total = total
        self.hasMoreData = hasMoreData
        self.heroes = heroes
    }
}
