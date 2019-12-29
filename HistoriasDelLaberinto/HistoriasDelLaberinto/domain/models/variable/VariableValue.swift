enum VariableType: String, Decodable {
    case boolean, integer, string
}

struct VariableValue: Decodable {
    let type: VariableType
    var value: String
    
    init?(type: String?, value: String?) {
        guard let type = type, let value = value else { return nil }
        switch type {
        case "string":
            self.type = .string
            self.value = value
        case "integer":
            guard Int(value) != nil else { return nil }
            self.type = .integer
            self.value = value
        case "boolean":
            guard Bool(value) != nil else { return nil }
            self.type = .boolean
            self.value = value
        default:
            return nil
        }
    }
    
    func getInt() -> Int? {
        return Int(value)
    }
    
    func getBool() -> Bool? {
        return Bool(value)
    }
}

extension VariableValue: Equatable {
    static func == (lhs: VariableValue, rhs: VariableValue) -> Bool {
        switch (lhs.type, rhs.type) {
        case (.integer, .integer):
            return lhs.getInt() == rhs.getInt()
        case (.string, .string):
            return lhs.value == rhs.value
        case (.boolean, .boolean):
            return lhs.getBool() == rhs.getBool()
        default:
            return false
        }
    }
}
