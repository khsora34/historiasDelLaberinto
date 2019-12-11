struct ConditionVariable: Decodable {
    let comparationVariableName: String
    let relation: VariableRelation
    let initialVariable: VariableValue?
    let initialVariableName: String?
    
    init(variableToCompareId: String, relation: VariableRelation, initialVariable: VariableValue) {
        self.comparationVariableName = variableToCompareId
        self.relation = relation
        self.initialVariable = initialVariable
        self.initialVariableName = nil
    }
    
    init(variableToCompareId: String, relation: VariableRelation, initialVariableName: String) {
        self.comparationVariableName = variableToCompareId
        self.relation = relation
        self.initialVariableName = initialVariableName
        self.initialVariable = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.comparationVariableName = try container.decode(String.self, forKey: .comparationVariableName)
        self.relation = try container.decode(VariableRelation.self, forKey: .relation)
        
        if let initialVariable = try? container.decode(VariableValue.self, forKey: .initialVariable) {
            self.initialVariable = initialVariable
            self.initialVariableName = nil
        } else if let initialVariableName = try? container.decode(String.self, forKey: .initialVariable) {
            self.initialVariableName = initialVariableName
            self.initialVariable = nil
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.initialVariable, in: container, debugDescription: "Unable to parse initial variable value for variable condition.")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case comparationVariableName = "compareToId"
        case relation
        case initialVariable = "initialVariable"
    }
}

extension ConditionVariable: Equatable {
    static func == (lhs: ConditionVariable, rhs: ConditionVariable) -> Bool {
        return lhs.comparationVariableName == rhs.comparationVariableName && lhs.relation == rhs.relation &&
            lhs.initialVariableName == rhs.initialVariableName && lhs.initialVariable == rhs.initialVariable
    }
}
