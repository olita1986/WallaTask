//
//  ListHeroesHandlerMock.swift
//  WallaMarvelTests
//
//  Created by orlando arzola on 02-05-25.
//

import Foundation
@testable import WallaMarvel

final class ListHeroesHandlerMock: ListHeroesHandlerProtocol {
    
    private(set) var getDataCallCount = 0
    private(set) var getRequestedHeroesCallCount = 0
    private(set) var searchText: String?
    var result: Result<[CharacterDataModel], Error> = .success([])
    
    func getData(initialHeroes: Bool, forceRefresh: Bool) async throws -> [CharacterDataModel] {
        getDataCallCount += 1
        return try result.get()
    }
    
    func getRequestedHeroes(withText text: String?) async throws -> [CharacterDataModel] {
        searchText = text
        getRequestedHeroesCallCount += 1
        return try result.get()
    }
}
