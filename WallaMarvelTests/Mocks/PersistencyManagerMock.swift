//
//  PersistencyManagerMock.swift
//  WallaMarvelTests
//
//  Created by orlando arzola on 04-05-25.
//

import Foundation
@testable import WallaMarvel

final class PersistencyManagerMock: PersistencyManagerProtocol {
    private(set) var saveHeroesDataCallCount = 0
    private(set) var loadHeroesDataCallCount = 0
    private(set) var clearCacheCallCount = 0

    var paginationModel: PaginationModel?

    func saveHeroesData(heroesData: PaginationModel) {
        saveHeroesDataCallCount += 1
    }
    
    func loadHeroesData() -> PaginationModel? {
        loadHeroesDataCallCount += 1
        return paginationModel
    }
    
    func clearCache() {
        clearCacheCallCount += 1
        paginationModel = nil
    }
}
