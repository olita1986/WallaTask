//
//  GetHeroesUseCaseMock.swift
//  WallaMarvelTests
//
//  Created by orlando arzola on 03-05-25.
//

import Foundation
@testable import WallaMarvel

final class GetHeroesUseCaseMock: GetHeroesUseCaseProtocol {
    private(set) var executeCallCount = 0
    var result: Result<CharacterDataContainer, Error> = .success(.make())
    func execute(offset: Int, limit: Int) async throws -> CharacterDataContainer {
        executeCallCount += 1
        return try result.get()
    }
}
