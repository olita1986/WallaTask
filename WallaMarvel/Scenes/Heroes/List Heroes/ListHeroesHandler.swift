//
//  ListHeroesHandler.swift
//  WallaMarvel
//
//  Created by orlando arzola on 02-05-25.
//

import Foundation

protocol ListHeroesHandlerProtocol {
    func getData(initialHeroes: Bool, forceRefresh: Bool) async throws -> [CharacterDataModel]
}

final class ListHeroesHandler: ListHeroesHandlerProtocol {
    private var currentOffset = 0
    private let limit = 15
    private var heroes = [CharacterDataModel]()
    private var hasMoreHeroes = true
    
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    private let persistencyManager: PersistencyManagerProtocol

    init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes(),
         persistencyManager: PersistencyManagerProtocol = PersistencyManager()) {
        self.getHeroesUseCase = getHeroesUseCase
        self.persistencyManager = persistencyManager
    }
    
    func getData(initialHeroes: Bool, forceRefresh: Bool) async throws -> [CharacterDataModel] {
        // If we are fetching initial heroes or force refresh then we reset offset and hasMoreHeroes
        if initialHeroes || forceRefresh {
            currentOffset = 0
            hasMoreHeroes = true
            // If we are not forcing refresh then we get the cached data
            if !forceRefresh {
                if let heroesData = persistencyManager.loadHeroesData() {
                    currentOffset = heroesData.offset
                    hasMoreHeroes = heroesData.hasMoreData
                    heroes = heroesData.heroes
                    return heroes
                }
            } else {
                persistencyManager.clearCache()
            }
        }
        
        // If there is no more heroes to load show a message
        guard hasMoreHeroes else {
            throw PaginationError.noMoreData
        }

        // Get data
        let characterDataContainer = try await getHeroesUseCase.execute(offset: currentOffset, limit: limit)
        // Increase the offset
        currentOffset += characterDataContainer.count
        // Check if there is more heroes to load
        hasMoreHeroes = currentOffset < characterDataContainer.total
        // If it's initial load or force refresh then replace the entire heroes else append then
        if initialHeroes || forceRefresh {
            heroes = characterDataContainer.characters
        } else {
            heroes += characterDataContainer.characters
        }
        saveHeroesData()
        return heroes
    }
    
    func saveHeroesData() {
        let paginationModel = PaginationModel(offset: currentOffset,
                                              hasMoreData: hasMoreHeroes,
                                              heroes: heroes)
        persistencyManager.saveHeroesData(heroesData: paginationModel)
    }
}

enum PaginationError: Error, LocalizedError {
    case noMoreData
    
    var errorDescription: String? {
        switch self {
        case .noMoreData:
            return "There is no more data"
        }
    }
}
