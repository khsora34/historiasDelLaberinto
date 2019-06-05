protocol MovementSceneBusinessLogic: BusinessLogic {
    func getMovement() -> MovementScene.GetMovement.Response
    func saveMovement()
    func getRoom(request: MovementScene.GetRoom.Request) -> MovementScene.GetRoom.Response
    func getAllRooms(request: MovementScene.GetAllRooms.Request) -> MovementScene.GetAllRooms.Response
}

class MovementSceneInteractor: BaseInteractor, MovementSceneBusinessLogic {
    private let roomFetcher: RoomFetcher
    private let movementFetcher: MovementFetcher
    
    init(roomFetcher: RoomFetcher, movementFetcher: MovementFetcher) {
        self.roomFetcher = roomFetcher
        self.movementFetcher = movementFetcher
    }
    
    func getMovement() -> MovementScene.GetMovement.Response {
        if let movement = movementFetcher.getMovement() {
            return MovementScene.GetMovement.Response(movement: movement)
        }
        return MovementScene.GetMovement.Response(movement: movementFetcher.createMovement())
    }
    
    func saveMovement() {
        _ = movementFetcher.save()
    }
    
    func getRoom(request: MovementScene.GetRoom.Request) -> MovementScene.GetRoom.Response {
        let id = request.id
        let room = roomFetcher.getRoom(with: id)
        return MovementScene.GetRoom.Response(room: room)
    }
    
    func getAllRooms(request: MovementScene.GetAllRooms.Request) -> MovementScene.GetAllRooms.Response {
        let rooms = roomFetcher.getAllRooms()
        let movement = request.movement
        
        let genericRooms = rooms.filter({ $0.isGenericRoom == true })
        var availableRooms: [Room] = rooms.filter({ $0.isGenericRoom == false})
        
        if let items = movement.map, let map = Array(items) as? [RoomPosition] {
            availableRooms = rooms.filter { room in map.filter({ $0.roomId == room.id }).isEmpty }
        }
        
        return MovementScene.GetAllRooms.Response(availableRooms: availableRooms, genericRooms: genericRooms)
    }
}
