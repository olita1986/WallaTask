import Foundation

protocol APIClientProtocol {
    func makeRequest<T: Decodable>(model: T.Type,
                                   endpoint: String,
                                   parameters: [String : String]?) async throws -> T
}

final class APIClient: APIClientProtocol {
    
    static let shared = APIClient()

    private enum Constant {
        static let privateKey = "bfb693b074fe878aae4de08d3a69142789875b1c"
        static let publicKey = "428d83e6ad1718e08d61ee45dacca712"
    }
    
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
        let privateKey = Constant.privateKey
        let publicKey = Constant.publicKey
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
