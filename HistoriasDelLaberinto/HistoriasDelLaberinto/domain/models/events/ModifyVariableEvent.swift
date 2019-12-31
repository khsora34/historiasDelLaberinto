struct ModifyVariableEvent: Event, Decodable {
    let id: String
    let nextStep: String?
    let shouldSetVisited: Bool?
    let shouldEndGame: Bool?
    let variableId: String
    let operation: VariableOperation
    let initialVariable: VariableValue?
    let initialVariableName: String?
    
    init(id: String, nextStep: String?, shouldSetVisited: Bool?, shouldEndGame: Bool?, variableId: String, operation: VariableOperation, initialVariable: VariableValue) {
        self.id = id
        self.nextStep = nextStep
        self.shouldEndGame = shouldEndGame
        self.shouldSetVisited = shouldSetVisited
        self.variableId = variableId
        self.operation = operation
        self.initialVariable = initialVariable
        self.initialVariableName = nil
    }
    
    init(id: String, nextStep: String?, shouldSetVisited: Bool?, shouldEndGame: Bool?, variableId: String, operation: VariableOperation, initialVariableName: String) {
        self.id = id
        self.nextStep = nextStep
        self.shouldEndGame = shouldEndGame
        self.shouldSetVisited = shouldSetVisited
        self.variableId = variableId
        self.operation = operation
        self.initialVariableName = initialVariableName
        self.initialVariable = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nextStep = try container.decodeIfPresent(String.self, forKey: .nextStep)
        self.shouldEndGame = try container.decodeIfPresent(Bool.self, forKey: .shouldEndGame)
        self.shouldSetVisited = try container.decodeIfPresent(Bool.self, forKey: .shouldSetVisited)
        self.variableId = try container.decode(String.self, forKey: .variableId)
        self.operation = try container.decode(VariableOperation.self, forKey: .operation)
        
        if let initialVariable = try? container.decode(VariableValue.self, forKey: .initialVariable) {
            self.initialVariable = initialVariable
            self.initialVariableName = nil
        } else if let initialVariableName = try? container.decode(String.self, forKey: .initialVariable) {
            self.initialVariableName = initialVariableName
            self.initialVariable = nil
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.initialVariable, in: container, debugDescription: "Unable to parse initial variable value for modify variable event.")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case nextStep
        case shouldSetVisited
        case shouldEndGame
        case variableId
        case operation
        case initialVariable
    }
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
    
    func isAvailable(forType type: VariableType) -> Bool {
        if type == .string {
            return stringOperations.contains(self)
        } else if type == .boolean {
            return boolOperations.contains(self)
        } else if type == .integer {
            return intOperations.contains(self)
        } else {
            return false
        }
    }
    
    func performOperation(originalContent: VariableValue, newContent: VariableValue) -> VariableValue {
        guard isAvailable(forType: originalContent.type) else { return originalContent }
        switch originalContent.type {
        case .integer:
            guard let lhs = originalContent.getInt(), let rhs = newContent.getInt() else { return originalContent }
            let newValue = "\(performIntOperation(lhs: lhs, rhs: rhs))"
            return VariableValue(type: .integer, value: newValue)
        case .boolean:
            guard let lhs = originalContent.getBool(), let rhs = newContent.getBool() else { return originalContent }
            let newValue = "\(performBooleanOperation(lhs: lhs, rhs: rhs))"
            return VariableValue(type: .boolean, value: newValue)
        case .string:
            let newValue = performStringOperation(lhs: originalContent.value, rhs: newContent.value)
            return VariableValue(type: .string, value: newValue)
        }
    }
    
    private func performIntOperation(lhs: Int, rhs: Int) -> Int {
        switch self {
        case .add:
            return lhs + rhs
        case .subt:
            return lhs - rhs
        case .mult:
            return lhs * rhs
        case .div:
            return lhs / rhs
        case .mod:
            return lhs % rhs
        case .set:
            return rhs
        default:
            return lhs
        }
    }
    
    private func performBooleanOperation(lhs: Bool, rhs: Bool) -> Bool {
        switch self {
        case .and:
            return lhs && rhs
        case .or:
            return lhs || rhs
        case .not:
            return !rhs
        case .set:
            return rhs
        default:
            return lhs
        }
    }
    
    private func performStringOperation(lhs: String, rhs: String) -> String {
        switch self {
        case .concat:
            return lhs + rhs
        case .set:
            return rhs
        default:
            return lhs
        }
    }
}

typealias ModifyVariableEventParser = YamlParser<ModifyVariableEvent>
