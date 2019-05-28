class RouterProvider {
    let moduleProvider: ModuleProvider
    let drawer: MainViewController
    
    init(drawer: MainViewController, moduleProvider: ModuleProvider) {
        self.drawer = drawer
        self.moduleProvider = moduleProvider
    }
    
    var exampleSceneRouter: ExampleSceneRoutingLogic {
        return ExampleSceneRouter(moduleProvider: moduleProvider, drawer: drawer)
    }
    
    var voidRouter: VoidRoutingLogic {
        return VoidRouter(moduleProvider: moduleProvider, drawer: drawer)
    }
}
