import Foundation

protocol Parser {
    associatedtype Parseable
    func serialize(_ responseString: String) -> Parseable?
}
