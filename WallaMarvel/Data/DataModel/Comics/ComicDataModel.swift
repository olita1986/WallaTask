//
//  ComicDataModel.swift
//  WallaMarvel
//
//  Created by orlando arzola on 01-05-25.
//

import Foundation

struct ComicDataModel: Decodable {
    let id: Int
    let title: String
    let description: String
    let thumbnail: Thumbnail
    let series: Serie
}

struct Serie: Decodable {
    let name: String
}
