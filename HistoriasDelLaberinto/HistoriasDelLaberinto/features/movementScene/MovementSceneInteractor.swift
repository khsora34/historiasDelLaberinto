protocol MovementSceneBusinessLogic: BusinessLogic {
    func getMovement() -> MovementScene.GetMovement.Response
    func saveMovement()
    func setNewLocation(request: MovementScene.SetLocation.Request)
    func getRoom(request: MovementScene.GetRoom.Request) -> MovementScene.GetRoom.Response
    func getAllRooms(request: MovementScene.GetAllRooms.Request) -> MovementScene.GetAllRooms.Response
}

class MovementSceneInteractor: BaseInteractor, MovementSceneBusinessLogic {
    private let roomFetcher: RoomFetcher
    private let movementFetcher: MovementFetcher
    
    init(databaseFetcherProvider: DatabaseFetcherProvider) {
        self.roomFetcher = databaseFetcherProvider.roomsFetcher
        self.movementFetcher = databaseFetcherProvider.movementFetcher
        super.init(localizedStringAccess: databaseFetcherProvider.localizedValueFetcher)
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
    
    func setNewLocation(request: MovementScene.SetLocation.Request) {
        let location = request.location
        let id = request.roomId
        let movement = request.movement
        
        movement.actualX = Int16(location.0)
        movement.actualY = Int16(location.1)
        
        if let items = movement.map, let map = Array(items) as? [RoomPosition], !map.isEmpty {
            let searchRoom = map.filter({ $0.x == location.0 && $0.y == location.1 })
            
            if searchRoom.count == 0 {
                movementFetcher.registerPosition(location: location, roomId: id, on: movement)
            }
        }
        
        saveMovement()
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
            availableRooms = availableRooms.filter { room in map.filter({ $0.roomId == room.id }).isEmpty }
        }
        
        return MovementScene.GetAllRooms.Response(availableRooms: availableRooms, genericRooms: genericRooms)
    }
}
