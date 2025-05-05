import Foundation

protocol MarvelRepositoryProtocol {
    func getHeroes(offset: Int, limit: Int, searchQuery: String?) async throws -> CharacterDataContainer
    func getComics(forHeroId heroId: Int) async throws -> ComicDataContainer
}

final class MarvelRepository: MarvelRepositoryProtocol {
    private let dataSource: MarvelDataSourceProtocol
    
    init(dataSource: MarvelDataSourceProtocol = MarvelDataSource()) {
        self.dataSource = dataSource
    }
    
    func getHeroes(offset: Int, limit: Int, searchQuery: String?) async throws -> CharacterDataContainer {
        try await dataSource.getHeroes(offset: offset, limit: limit, searchQuery: searchQuery)
    }
    
    func getComics(forHeroId heroId: Int) async throws -> ComicDataContainer {
        try await dataSource.getComics(forHeroId: heroId)
    }
}
