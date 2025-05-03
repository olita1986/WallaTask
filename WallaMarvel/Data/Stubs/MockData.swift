//
//  MockData.swift
//  WallaMarvel
//
//  Created by orlando arzola on 03-05-25.
//

import Foundation
import OHHTTPStubs

final class MockData {
    func setupStubs() {
        stub(condition: isHost("gateway.marvel.com") && isPath("/v1/public/characters")) { _ in
            HTTPStubsResponse(fileAtPath: OHPathForFile("characters_200.json", type(of: self))!,
                              statusCode: 200,
                              headers: nil)
        }
    }
    
    func setupErrorStubs() {
        stub(condition: isHost("gateway.marvel.com") && isPath("/v1/public/characters")) { _ in
            HTTPStubsResponse(error: NetworkError.invalidResponse)
        }
    }
}
