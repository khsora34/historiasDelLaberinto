import Foundation
enum VariableRelation: String, Decodable {
    case equal, notEqual, greater, lower, greaterOrEqual, lowerOrEqual
    
    func evaluate(left: Bool, right: Bool) -> Bool {
        switch self {
        case .equal:
            return left == right
        case .notEqual:
            return left != right
        case .greater:
            return left && !right
        case .lower:
            return !left && right
        case .greaterOrEqual:
            return left || (!left && !right)
        case .lowerOrEqual:
            return !left || (left && right)
        }
    }
    
    func evaluate(left: String, right: String) -> Bool {
        switch self {
        case .equal:
            return left == right
        case .notEqual:
            return left != right
        case .greater:
            return left > right
        case .lower:
            return left < right
        case .greaterOrEqual:
            return left >= right
        case .lowerOrEqual:
            return left <= right
        }
    }
    
    func evaluate(left: Int, right: Int) -> Bool {
        switch self {
        case .equal:
            return left == right
        case .notEqual:
            return left != right
        case .greater:
            return left > right
        case .lower:
            return left < right
        case .greaterOrEqual:
            return left >= right
        case .lowerOrEqual:
            return left <= right
        }
    }
}
