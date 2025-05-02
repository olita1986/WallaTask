import Foundation

protocol MarvelDataSourceProtocol {
    func getHeroes(offset: Int, limit: Int) async throws -> CharacterDataContainer
    func getComics(forHeroId heroId: Int) async throws -> ComicDataContainer
}

final class MarvelDataSource: MarvelDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getHeroes(offset: Int, limit: Int) async throws -> CharacterDataContainer {
        let heroesEndpoint = "/characters"
        let parameters = ["offset": String(offset),
                          "limit": String(limit)]
        return try await apiClient.makeRequest(model: CharacterDataContainer.self,
                                               endpoint: heroesEndpoint,
                                               parameters: parameters)
    }
    
    func getComics(forHeroId heroId: Int) async throws -> ComicDataContainer {
        let comicsURLString = "/comics"
        let parameters = ["characters": String(heroId)]
        return try await apiClient.makeRequest(model: ComicDataContainer.self,
                                               endpoint: comicsURLString,
                                               parameters: parameters)
    }
}
