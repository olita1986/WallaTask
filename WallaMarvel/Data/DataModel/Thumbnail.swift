import Foundation

struct Thumbnail: Decodable, Equatable {
    let path: String
    let `extension`: String
    
    var url: URL? {
        URL(string: self.path + "/portrait_small." + self.extension)
    }
}
