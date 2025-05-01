//
//  GetComics.swift
//  WallaMarvel
//
//  Created by orlando arzola on 01-05-25.
//

import Foundation

protocol GetComicsUseCaseProtocol {
    func execute(forHeroId heroId: Int) async throws -> ComicDataContainer
}

struct GetComics: GetComicsUseCaseProtocol {
    private let repository: MarvelRepositoryProtocol
    
    init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
        self.repository = repository
    }
    
    func execute(forHeroId heroId: Int) async throws -> ComicDataContainer {
        try await repository.getComics(forHeroId: heroId)
    }
}
