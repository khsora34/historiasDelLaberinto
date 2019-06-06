enum InitialScene {
    // MARK: Use cases
    enum RoomBuilder {
        struct Request {
            let roomId: String
        }
        struct Response {
            let room: Room?
        }
    }
    
    enum MovementGetter {
        struct Response {
            let movement: Movement?
        }
    }
}
