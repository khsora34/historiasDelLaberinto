import Foundation

protocol Parser {
    associatedtype Parseable
    func serialize(_ responseString: String) -> Parseable?
    func deserialize(_ parseable: Parseable) -> String?
}
