class GameSession {
    static var protagonist: Protagonist!
    static var partners: [String: PlayableCharacter] = [:]
    static var movement: Movement!
    static var variables: [String: Variable] = [:]
    static var rooms: [String: Room] = [:]
    
    static func setProtagonist(_ protagonist: Protagonist) {
        self.protagonist = protagonist
    }
    
    static func addPartner(_ partner: PlayableCharacter, withId id: String) {
        self.partners[id] = partner
    }
    
    static func setMovement(_ movement: Movement) {
        self.movement = movement
    }
    
    static func addVariable(_ variable: Variable) {
        self.variables[variable.name] = variable
    }
    
    static func addRoom(_ room: Room) {
        self.rooms[room.id] = room
    }
}
