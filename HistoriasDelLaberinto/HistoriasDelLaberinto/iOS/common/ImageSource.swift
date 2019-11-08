import Foundation

enum ImageSource {
    case local(String)
    case remote(String)
    
    var name: String {
        switch self {
        case .local:
            return "local"
        case .remote:
            return "remote"
        }
    }
    
    var value: String {
        switch self {
        case .local(let path):
            return path
        case .remote(let path):
            return path
        }
    }
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
            self = .remote(urlPath)
        default:
            throw CodingError.unknownValue
        }
    }
}
