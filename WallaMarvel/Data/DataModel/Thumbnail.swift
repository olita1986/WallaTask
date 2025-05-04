import Foundation

struct Thumbnail: Codable, Equatable {
    let path: String
    let `extension`: String
    
    var url: URL? {
        URL(string: self.path + "/portrait_small." + self.extension)
    }
}
