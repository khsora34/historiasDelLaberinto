struct ModifyVariableEvent: Event, Decodable {
    let id: String
    let nextStep: String?
    let shouldSetVisited: Bool?
    let shouldEndGame: Bool?
    let variableId: String
    let operation: VariableOperation
    let initialVariable: VariableValue?
    let initialVariableName: String?
}

enum VariableOperation: String, Decodable {
    case set, and, or, not, add, subt, mult, div, mod, concat
    
    var intOperations: Set<VariableOperation> {
        [.set, .add, .subt, .mult, .div, .mod]
    }
    var boolOperations: Set<VariableOperation> {
        [.set, .and, .or, .not]
    }
    var stringOperations: Set<VariableOperation> {
        [.set, .concat]
    }
    
    func isAvailable(forType type: AnyClass) -> Bool {
        if type == String.self {
            return stringOperations.contains(self)
        } else if type == Bool.self {
            return boolOperations.contains(self)
        } else if type == Int.self {
            return intOperations.contains(self)
        } else {
            return false
        }
    }
}

typealias ModifyVariableEventParser = YamlParser<ModifyVariableEvent>
