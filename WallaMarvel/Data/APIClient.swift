import Foundation

protocol APIClientProtocol {
    func makeRequest<T: Decodable>(model: T.Type,
                                 withURL urlString: String) async throws -> T
}

final class APIClient: APIClientProtocol {
    private enum Constant {
        static let privateKey = "bfb693b074fe878aae4de08d3a69142789875b1c"
        static let publicKey = "428d83e6ad1718e08d61ee45dacca712"
    }
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func makeRequest<T: Decodable>(model: T.Type, withURL urlString: String) async throws -> T {
        let ts = String(Int(Date().timeIntervalSince1970))
        let privateKey = Constant.privateKey
        let publicKey = Constant.publicKey
        let hash = "\(ts)\(privateKey)\(publicKey)".md5
        let parameters: [String: String] = ["apikey": publicKey,
                                            "ts": ts,
                                            "hash": hash]
        
        var urlComponent = URLComponents(string: urlString)
        urlComponent?.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = urlComponent?.url else {
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
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}
