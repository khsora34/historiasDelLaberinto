class ModuleProvider {
    var routerProvider: RouterProvider!
    var databaseFetcherProvider: DatabaseFetcherProvider!
    
    init() {}
    
    func exampleSceneModule() -> Module {
        return ExampleSceneModule(routerProvider: routerProvider, databaseFetcherProvider: databaseFetcherProvider)
    }
    
    func initialSceneModule() -> Module {
        return InitialSceneModule(routerProvider: routerProvider, databaseFetcherProvider: databaseFetcherProvider)
    }
    
    func roomSceneModule(roomId: String, room: Room) -> Module {
        return RoomSceneModule(roomId: roomId, room: room, routerProvider: routerProvider, databaseFetcherProvider: databaseFetcherProvider)
    }
    
    func movementSceneModule(room: Room) -> Module {
        return MovementSceneModule(room: room, routerProvider: routerProvider, databaseProvider: databaseFetcherProvider)
    }
    
    func battleSceneModule() -> Module {
        return BattleSceneModule(routerProvider: routerProvider)
    }
}
