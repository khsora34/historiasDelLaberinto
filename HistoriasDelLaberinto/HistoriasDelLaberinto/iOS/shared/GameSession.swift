class GameSession {
    static var isDataSynced: Bool = true
    static var protagonist: Protagonist!
    static var partners: [String: PlayableCharacter] = [:]
    static var movement: Movement!
    static var variables: [String: Variable] = [:]
    static var rooms: [String: Room] = [:]
    
    static func startSession(protagonist: Protagonist, movement: Movement, partners: [(String, PlayableCharacter)] = []) {
        self.setProtagonist(protagonist)
        self.setMovement(movement)
        for partner in partners {
            self.addPartner(partner.1, withId: partner.0)
        }
        self.isDataSynced = true
    }
    
    static func restart() {
        protagonist = nil
        partners = [:]
        movement = nil
        variables = [:]
        rooms = [:]
        self.isDataSynced = true
    }
    
    static func setProtagonist(_ protagonist: Protagonist) {
        self.protagonist = protagonist
        self.isDataSynced = false
    }
    
    static func addPartner(_ partner: PlayableCharacter, withId id: String) {
        self.partners[id] = partner
        self.isDataSynced = false
    }
    
    static func setMovement(_ movement: Movement) {
        self.movement = movement
        self.isDataSynced = false
    }
    
    static func addVariable(_ variable: Variable) {
        self.variables[variable.name] = variable
        self.isDataSynced = false
    }
    
    static func addRoom(_ room: Room) {
        self.rooms[room.id] = room
        self.isDataSynced = false
    }
}
