protocol MovementScenePresentationLogic: Presenter {
    func dismiss()
    func calculateDirection(tag: Int)
    func continueToNewRoom()
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
    
    private var nextRoom: Room?
    private var nextLocation: (Int, Int)?
    
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
    }
    
    private func getRooms() {
        let request = MovementScene.GetAllRooms.Request(movement: movement)
        let response = interactor?.getAllRooms(request: request)
        genericRooms = response?.genericRooms
        availableRooms = response?.availableRooms
    }
}

extension MovementScenePresenter: MovementScenePresentationLogic {
    func calculateDirection(tag: Int) {
        guard let direction = CompassDirection(tag: tag) else { return }
        switch direction {
        case .north:
            willMoveTo(extraX: 0, extraY: 1)
        case .east:
            willMoveTo(extraX: 1, extraY: 0)
        case .west:
            willMoveTo(extraX: -1, extraY: 0)
        case .south:
            willMoveTo(extraX: 0, extraY: -1)
        }
    }
    
    private func willMoveTo(extraX: Int, extraY: Int) {
        let newX = Int(movement.actualX) + extraX
        let newY = Int(movement.actualY) + extraY
        
        if let items = movement.map, let map = Array(items) as? [RoomPosition], !map.isEmpty {
            let searchRoom = map.filter({ $0.x == newX && $0.y == newY })
            if let firstRoomId = searchRoom.first?.roomId {
                let request = MovementScene.GetRoom.Request(id: firstRoomId)
                let response = interactor?.getRoom(request: request)
                nextRoom = response?.room
            } else {
                nextRoom = getNewRoom()
            }
        } else {
            nextRoom = getNewRoom()
        }
        
        if nextRoom != nil {
            nextLocation = (newX, newY)
            viewController?.showConfirmationDialog()
        } else {
            viewController?.showCantMoveDialog()
        }
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
    
    func continueToNewRoom() {
        guard let newRoom = nextRoom, let location = nextLocation else { return }
        let request = MovementScene.SetLocation.Request(location: location, roomId: newRoom.id, movement: movement)
        interactor?.setNewLocation(request: request)
        router?.goToNewRoom(room: newRoom)
    }
    
    func dismiss() {
        router?.dismiss()
    }
}

enum CompassDirection: String {
    case north, east, west, south
    init?(tag: Int) {
        switch tag {
        case 0:
            self = .north
        case 1:
            self = .east
        case 2:
            self = .south
        case 3:
            self = .west
        default:
            return nil
        }
    }
}
