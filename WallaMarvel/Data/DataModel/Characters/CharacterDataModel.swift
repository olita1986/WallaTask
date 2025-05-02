import Foundation

struct CharacterDataModel: Decodable, Equatable {
    let id: Int
    let name: String
    let thumbnail: Thumbnail
    
    init(id: Int, name: String, thumbnail: Thumbnail) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
    }
}
