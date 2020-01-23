enum MovementScene {
    enum GetMovement {
        struct Response {
            let movement: Movement
        }
    }
    
    enum GetRoom {
        struct Request {
            let id: String
        }
        struct Response {
            let room: Room?
        }
    }
    
    enum GetAllRooms {
        struct Response {
            let storyRooms: [Room]
            let genericRooms: [Room]
        }
    }
    
    enum SetLocation {
        struct Request {
            let location: (Int, Int)
            let roomId: String
            let movement: Movement
        }
    }
}
