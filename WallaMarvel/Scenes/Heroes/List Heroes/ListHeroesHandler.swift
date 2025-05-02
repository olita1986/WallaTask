//
//  ListHeroesHandler.swift
//  WallaMarvel
//
//  Created by orlando arzola on 02-05-25.
//

import Foundation

protocol ListHeroesHandlerProtocol {
    func getData(initialHeroes: Bool) async throws -> [CharacterDataModel]
}

final class ListHeroesHandler: ListHeroesHandlerProtocol {
    private var currentOffset = 0
    private let limit = 15
    private var heroes = [CharacterDataModel]()
    private var hasMoreHeroes = true
    
    private let getHeroesUseCase: GetHeroesUseCaseProtocol

    init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
        self.getHeroesUseCase = getHeroesUseCase
    }
    
    func getData(initialHeroes: Bool) async throws -> [CharacterDataModel] {
        // If we are fetching initial heroes then we reset offset and hasMoreHeroes
        if initialHeroes {
            currentOffset = 0
            hasMoreHeroes = true
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
        // If it's initial load then replace the entire heroes else append then
        if initialHeroes {
            heroes = characterDataContainer.characters
        } else {
            heroes += characterDataContainer.characters
        }

        return heroes
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
