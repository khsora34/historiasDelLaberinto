class ModuleProvider {
    var routerProvider: RouterProvider!
    var databaseFetcherProvider: DatabaseFetcherProvider!
    
    init() {}
    
    func exampleSceneModule() -> Module {
        return ExampleSceneModule(routerProvider: routerProvider, eventsFetcherManager: databaseFetcherProvider.eventsFetcherManager)
    }
    
    func initialSceneModule() -> Module {
        return InitialSceneModule(routerProvider: routerProvider, databaseFetcherProvider: databaseFetcherProvider)
    }
    
    func dialogModule(nextStep: String) -> Module {
        return DialogModule(nextStep: nextStep, routerProvider: routerProvider, databaseFetcherProvider: databaseFetcherProvider)
    }
}
