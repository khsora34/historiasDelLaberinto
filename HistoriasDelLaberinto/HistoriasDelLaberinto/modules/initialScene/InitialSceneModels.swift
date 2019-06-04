enum InitialScene {
    // MARK: Use cases
    
    enum LoadFiles {
        struct Response {
            let stringResponse: String
        }
    }
    enum RoomBuilder {
        struct Request {
            let roomId: String
        }
        struct Response {
            let room: Room?
        }
    }
}
