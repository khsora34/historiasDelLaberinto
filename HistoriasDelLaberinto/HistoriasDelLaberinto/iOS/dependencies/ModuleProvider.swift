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
    
    func roomSceneModule() -> Module {
        return RoomSceneModule(routerProvider: routerProvider, databaseFetcherProvider: databaseFetcherProvider)
    }
}
