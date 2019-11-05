enum VariableTypeString: String {
    case boolean, integer, string
}

enum VariableValue: Decodable {
    case boolean(Bool)
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        let parsedValue = VariableTypeString(rawValue: rawValue)
        switch parsedValue {
        case .integer:
            let integer = try container.decode(Int.self, forKey: .associatedValue)
            self = .integer(integer)
        case .boolean:
            let boolean = try container.decode(Bool.self, forKey: .associatedValue)
            self = .boolean(boolean)
        case .string:
            let string = try container.decode(String.self, forKey: .associatedValue)
            self = .string(string)
        default:
            throw CodingError.unknownValue
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case rawValue = "type"
        case associatedValue = "value"
    }
    
    enum CodingError: Error {
        case unknownValue
    }
}
