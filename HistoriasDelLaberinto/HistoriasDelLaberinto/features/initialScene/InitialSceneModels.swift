enum InitialScene {
    // MARK: Use cases
    enum FileLoader {
        struct Request {
            let imageDelegate: ImageLoaderDelegate
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
    
    enum MovementGetter {
        struct Response {
            let movement: Movement?
        }
    }
}
