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
    var result: Result<[CharacterDataModel], Error> = .success([])
    func getData(initialHeroes: Bool, forceRefresh: Bool) async throws -> [CharacterDataModel] {
        getDataCallCount += 1
        return try result.get()
    }
}
