import Foundation

struct CharacterDataModel: Decodable {
    let id: Int
    let name: String
    let thumbnail: Thumbnail
}
