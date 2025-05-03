//
//  CharacterModelFactory.swift
//  WallaMarvelTests
//
//  Created by orlando arzola on 03-05-25.
//

import Foundation
@testable import WallaMarvel

extension CharacterDataModel {
    static func make(id: Int = 1234,
                     name: String = "Orlando",
                     thumbnail: Thumbnail = .make()) -> CharacterDataModel {
        CharacterDataModel(id: id,
                           name: name,
                           thumbnail: thumbnail)
    }
}

extension Thumbnail {
    static func make(path: String = "path",
                     extensionString: String = "extension") -> Thumbnail {
        Thumbnail(path: path,
                  extension: extensionString)
    }
}
