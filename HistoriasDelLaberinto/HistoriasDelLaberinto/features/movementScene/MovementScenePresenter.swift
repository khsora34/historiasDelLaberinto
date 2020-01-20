protocol MovementScenePresentationLogic: Presenter {
    func dismiss()
    func calculateDirection(tag: Int)
}

class MovementScenePresenter: BasePresenter {
    private let probabilityReducingFactor: Double = 0.2
    private let probabilityRaisingFactor: Double = 0.1
    
    var viewController: MovementSceneDisplayLogic? {
        return _viewController as? MovementSceneDisplayLogic
    }
    
    var interactor: MovementSceneInteractor? {
        return _interactor as? MovementSceneInteractor
    }
    
    var router: MovementSceneRouter? {
        return _router as? MovementSceneRouter
    }
    
    private let actualRoom: Room
    
    private var movement: Movement!
    private var genericRooms: [Room]!
    private var availableRooms: [Room]!
    private var savedMovements: [CompassDirection: Room] = [:]
    
    init(room: Room) {
        self.actualRoom = room
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovement()
        getRooms()
        viewController?.set(roomName: actualRoom.name)
    }
    
    private func getMovement() {
        let response = interactor?.getMovement()
        movement = response?.movement
        // Load rooms in any direction from actual room. It is meant for showing only the possible moves.
        if let items = movement.map, let map = Array(items) as? [RoomPosition], !map.isEmpty {
            for direction in CompassDirection.allCases {
                let extraLocation = direction.locationDirection()
                let newX = Int(movement.actualX) + extraLocation.0
                let newY = Int(movement.actualY) + extraLocation.1
                let searchRoom = map.filter({ $0.x == newX && $0.y == newY })
                
                guard let firstRoomId = searchRoom.first?.roomId else { continue }
                let request = MovementScene.GetRoom.Request(id: firstRoomId)
                let response = interactor?.getRoom(request: request)
                
                guard let room = response?.room else { continue }
                savedMovements[direction] = room
                viewController?.updateDirectionHidden(direction, isHidden: false)
            }
        }
    }
    
    private func getRooms() {
        let request = MovementScene.GetAllRooms.Request(movement: movement)
        let response = interactor?.getAllRooms(request: request)
        genericRooms = response?.genericRooms
        availableRooms = response?.availableRooms
        if !availableRooms.isEmpty {
            viewController?.showAllDirections()
        }
    }
}

extension MovementScenePresenter: MovementScenePresentationLogic {
    func calculateDirection(tag: Int) {
        guard let direction = CompassDirection(rawValue: tag) else { return }
        let extraMovement = direction.locationDirection()
        
        if let nextRoom = savedMovements[direction] {
            let nextLocation = (Int(movement.actualX) + extraMovement.0, Int(movement.actualY) + extraMovement.1)
            continueToNewRoom(room: nextRoom, location: nextLocation)
            return
        }
        
        willMoveTo(extraX: extraMovement.0, extraY: extraMovement.1)
    }
    
    private func willMoveTo(extraX: Int, extraY: Int) {
        guard let nextRoom = getNewRoom() else { return }
        
        let newX = Int(movement.actualX) + extraX
        let newY = Int(movement.actualY) + extraY
        
        let nextLocation = (newX, newY)
        
        continueToNewRoom(room: nextRoom, location: nextLocation)
    }
    
    private func getNewRoom() -> Room? {
        guard !availableRooms.isEmpty else { return nil }
        
        var usingRooms: [Room] = availableRooms
        if Double.random(in: 0..<1) < movement.genericProb, !genericRooms.isEmpty {
            movement.genericProb = movement.genericProb - probabilityReducingFactor < 0 ? 0: movement.genericProb - probabilityReducingFactor
            usingRooms = genericRooms
        } else {
            movement.genericProb = movement.genericProb + probabilityRaisingFactor > 1 ? 1: movement.genericProb + probabilityRaisingFactor
        }
        
        let randomIndex = usingRooms.count == 1 ? 0: Int.random(in: 0..<(usingRooms.count-1))
        
        return usingRooms[randomIndex]
    }
    
    private func continueToNewRoom(room: Room, location: (Int, Int)) {
        let request = MovementScene.SetLocation.Request(location: location, roomId: room.id, movement: movement)
        interactor?.setNewLocation(request: request)
        router?.goToNewRoom(room: room)
    }
    
    func dismiss() {
        router?.dismiss()
    }
}

enum CompassDirection: Int, CaseIterable {
    case north = 0, east, south, west
    
    func locationDirection() -> (Int, Int) {
        switch self {
        case .north:
            return (0, 1)
        case .east:
            return (1, 0)
        case .west:
            return (-1, 0)
        case .south:
            return (0, -1)
        }
    }
}
