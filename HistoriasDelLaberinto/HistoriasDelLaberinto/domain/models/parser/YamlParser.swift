import Foundation
import Yams

/// Generic class to create parsers for Codable types for yaml coding.
class YamlParser<Parseable: Codable>: Parser {    
    func serialize(_ responseString: String) -> Parseable? {
        return try? YAMLDecoder().decode(Parseable.self, from: responseString)
    }
    
    func deserialize(_ data: Parseable) -> String? {
        return try? YAMLEncoder().encode(data)
    }
}
