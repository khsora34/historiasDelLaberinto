import Foundation

enum ImageSource {
    case local(String)
    case remote(URL)
}

extension ImageSource: Decodable {
    enum CodingKeys: String, CodingKey {
        case typeValue = "type"
        case sourceValue = "source"
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .typeValue)
        switch rawValue {
        case "local":
            let fileName = try container.decode(String.self, forKey: .sourceValue)
            self = .local(fileName)
        case "remote":
            let urlPath = try container.decode(String.self, forKey: .sourceValue)
            guard let url = URL(string: urlPath) else {
                throw CodingError.unknownValue
            }
            self = .remote(url)
        default:
            throw CodingError.unknownValue
        }
    }
}
