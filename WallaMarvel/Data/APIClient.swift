import Foundation
import Keys

protocol APIClientProtocol {
    func makeRequest<T: Decodable>(model: T.Type,
                                   endpoint: String,
                                   parameters: [String : String]?) async throws -> T
}

final class APIClient: APIClientProtocol {
    
    static let shared = APIClient()

    private let keys = WallaMarvelKeys()
    
    private let urlSession: URLSession
    private let baseURLString = "https://gateway.marvel.com/v1/public"
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func makeRequest<T: Decodable>(model: T.Type,
                                   endpoint: String,
                                   parameters: [String: String]?) async throws -> T {
        guard let url = createURL(endpoint: endpoint, parameters: parameters) else {
            throw NetworkError.invalidURL
        }

        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    private func createURL(endpoint: String, parameters: [String : String]?) -> URL? {
        let ts = String(Int(Date().timeIntervalSince1970))
        let privateKey = keys.privateApiKey
        let publicKey = keys.publicApiKey
        let hash = "\(ts)\(privateKey)\(publicKey)".md5
        var baseParameters: [String: String] = ["apikey": publicKey,
                                                "ts": ts,
                                                "hash": hash]
        if let parameters {
            for (key, value) in parameters {
                baseParameters[key] = value
            }
        }
        
        guard var urlComponents = URLComponents(string: baseURLString + endpoint) else {
            return nil
        }
    
        urlComponents.queryItems = baseParameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        return urlComponents.url
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}
