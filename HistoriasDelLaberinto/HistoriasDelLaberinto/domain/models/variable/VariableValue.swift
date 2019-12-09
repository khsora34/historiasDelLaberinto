enum VariableTypeString: String {
    case boolean, integer, string
}

enum VariableValue: Decodable {
    case boolean(Bool)
    case integer(Int)
    case string(String)
    
    var type: VariableTypeString {
        switch self {
        case .boolean:
            return VariableTypeString.boolean
        case .integer:
            return VariableTypeString.integer
        case .string:
            return VariableTypeString.string
        }
    }
    
    var valueAsString: String {
        switch self {
        case .boolean(let value):
            return value.description
        case .integer(let value):
            return value.description
        case .string(let value):
            return value
        }
    }
    
    init?(type: String?, value: String?) {
        guard let type = type, let value = value else { return nil }
        switch type {
        case "string":
            self = .string(value)
        case "integer":
            guard let value = Int(value) else { return nil }
            self = .integer(value)
        case "boolean":
            guard let value = Bool(value) else { return nil }
            self = .boolean(value)
        default:
            return nil
        }
    }
}

extension VariableValue {
    enum CodingKeys: String, CodingKey {
        case rawValue = "type"
        case associatedValue = "value"
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
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
}

extension VariableValue: Equatable {}
