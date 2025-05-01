import Foundation

protocol MarvelDataSourceProtocol {
    func getHeroes() async throws -> CharacterDataContainer
    func getComics(forHeroId heroId: Int) async throws -> ComicDataContainer
}

final class MarvelDataSource: MarvelDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getHeroes() async throws -> CharacterDataContainer {
        let heroesEndpoint = "/characters"
        return try await apiClient.makeRequest(model: CharacterDataContainer.self,
                                               endpoint: heroesEndpoint,
                                               parameters: nil)
    }
    
    func getComics(forHeroId heroId: Int) async throws -> ComicDataContainer {
        let comicsURLString = "/comics"
        let parameters = ["characters": String(heroId)]
        return try await apiClient.makeRequest(model: ComicDataContainer.self,
                                               endpoint: comicsURLString,
                                               parameters: parameters)
    }
}
