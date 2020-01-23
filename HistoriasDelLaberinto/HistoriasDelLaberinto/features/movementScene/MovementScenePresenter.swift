protocol MovementScenePresentationLogic: Presenter {
    func dismiss()
    func calculateNextRoom(tag: Int)
}

class MovementScenePresenter: BasePresenter {
    private let probabilityReducingFactor: Double = 0.2
    private let probabilityRaisingFactor: Double = 0.1
    
    var viewController: MovementSceneDisplayLogic? { return _viewController as? MovementSceneDisplayLogic }
    var interactor: MovementSceneInteractor? { return _interactor as? MovementSceneInteractor }
    var router: MovementSceneRouter? { return _router as? MovementSceneRouter }
    
    private let actualRoom: Room
    private var movement: Movement
    
    private var genericRooms: [Room] = []
    private var storyRooms: [Room] = []
    private lazy var availableRooms: [Room] = {
        guard let items = movement.map, let map = Array(items) as? [RoomPosition] else { return [] }
        return storyRooms.filter { room in map.filter({ $0.roomId == room.id }).isEmpty }
    }()
    
    private var savedMovements: [CompassDirection: Room] = [:]
    
    init(room: Room) {
        self.actualRoom = room
        self.movement = GameSession.movement
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRooms()
        enableDirections()
        viewController?.set(roomName: actualRoom.name)
    }
    
    private func enableDirections() {
        // Load rooms in any direction from actual room. It is meant for showing only the possible moves.
        guard let items = movement.map, let map = Array(items) as? [RoomPosition], !map.isEmpty else { return }
        for direction in CompassDirection.allCases {
            let extraLocation = direction.locationDirection()
            let newX = Int(movement.actualX) + extraLocation.0
            let newY = Int(movement.actualY) + extraLocation.1
            let searchRoom = map.filter({ $0.x == newX && $0.y == newY })
            
            guard let firstRoomId = searchRoom.first?.roomId else { continue }
            
            if let room = storyRooms.first(where: { $0.id == firstRoomId }) {
                savedMovements[direction] = room
                viewController?.updateDirectionHidden(direction, isHidden: false)
            } else if let room = genericRooms.first(where: { $0.id == firstRoomId }) {
                savedMovements[direction] = room
                viewController?.updateDirectionHidden(direction, isHidden: false)
            }
        }
    }
    
    private func getRooms() {
        let response = interactor?.getAllRooms()
        genericRooms = response?.genericRooms ?? []
        storyRooms = response?.storyRooms ?? []
        if !availableRooms.isEmpty {
            viewController?.showAllDirections()
        }
    }
}

extension MovementScenePresenter: MovementScenePresentationLogic {
    func calculateNextRoom(tag: Int) {
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
        
        let randomIndex = Int.random(in: 0..<(usingRooms.count))
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
