protocol MovementSceneBusinessLogic: BusinessLogic {
    func setNewLocation(request: MovementScene.SetLocation.Request)
    func getAllRooms() -> MovementScene.GetAllRooms.Response
}

class MovementSceneInteractor: BaseInteractor, MovementSceneBusinessLogic {
    private let roomFetcher: RoomFetcher
    private let movementFetcher: MovementFetcher
    
    init(databaseFetcherProvider: DatabaseFetcherProvider) {
        self.roomFetcher = databaseFetcherProvider.roomsFetcher
        self.movementFetcher = databaseFetcherProvider.movementFetcher
        super.init(localizedStringAccess: databaseFetcherProvider.localizedValueFetcher)
    }
    
    func setNewLocation(request: MovementScene.SetLocation.Request) {
        let location = request.location
        let id = request.roomId
        let movement = request.movement
        
        movement.actualX = Int16(location.0)
        movement.actualY = Int16(location.1)
        
        if let items = movement.map, let map = Array(items) as? [RoomPosition], !map.isEmpty {
            let searchRoom = map.filter({ $0.x == location.0 && $0.y == location.1 })
            
            if searchRoom.isEmpty {
                movementFetcher.registerPosition(location: location, roomId: id, on: movement)
            }
        }
        
        GameSession.setMovement(movement)
    }
    
    func getAllRooms() -> MovementScene.GetAllRooms.Response {
        let rooms = roomFetcher.getAllRooms()
        let mergedRooms = rooms.merging(GameSession.rooms) { (_, new) -> Room in new }
        let genericRooms = mergedRooms.values.filter({ $0.isGenericRoom == true })
        let storyRooms = mergedRooms.values.filter({ $0.isGenericRoom == false })
        return MovementScene.GetAllRooms.Response(storyRooms: storyRooms, genericRooms: genericRooms)
    }
}
