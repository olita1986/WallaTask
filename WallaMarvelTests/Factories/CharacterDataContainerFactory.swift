//
//  CharacterDataContainerFactory.swift
//  WallaMarvelTests
//
//  Created by orlando arzola on 03-05-25.
//

import Foundation
@testable import WallaMarvel

extension CharacterDataContainer {
    static func make(count: Int = 0,
                     limit: Int = 0,
                     offset: Int = 0,
                     total: Int = 0,
                     characters: [CharacterDataModel] = []) -> CharacterDataContainer {
        CharacterDataContainer(count: count,
                               limit: limit,
                               offset: offset,
                               total: total,
                               characters: characters)
    }
}
