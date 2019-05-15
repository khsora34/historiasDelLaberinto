class ModuleProvider {
    var routerProvider: RouterProvider!
    var eventsFetcherManager: EventsFetcherManager!
    
    init() {}
    
    func exampleSceneModule() -> Module {
        return ExampleSceneModule(routerProvider: routerProvider, eventsFetcherManager: eventsFetcherManager)
    }
}
