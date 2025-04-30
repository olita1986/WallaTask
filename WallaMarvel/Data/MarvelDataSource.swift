import Foundation

protocol MarvelDataSourceProtocol {
    func getHeroes() async throws -> CharacterDataContainer
}

final class MarvelDataSource: MarvelDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getHeroes() async throws -> CharacterDataContainer {
        let heroesURLString = "https://gateway.marvel.com:443/v1/public/characters"
        return try await apiClient.makeRequest(model: CharacterDataContainer.self,
                                               withURL: heroesURLString)
    }
}
