class ModuleProvider {
    var routerProvider: RouterProvider!
    
    init() {}
    
    func exampleSceneModule() -> Module {
        return ExampleSceneModule(routerProvider: routerProvider)
    }
}
