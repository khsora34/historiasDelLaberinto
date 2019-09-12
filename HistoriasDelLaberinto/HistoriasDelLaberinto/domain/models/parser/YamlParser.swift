import Foundation
import Yams

/// Generic class to create parsers for Decodable types for yaml coding.
class YamlParser<Parseable: Decodable>: Parser {    
    func serialize(_ responseString: String) -> Parseable? {
        return try? YAMLDecoder().decode(Parseable.self, from: responseString)
    }
}
