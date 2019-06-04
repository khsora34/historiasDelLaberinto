class RouterProvider {
    let moduleProvider: ModuleProvider
    let drawer: MainViewController
    
    init(drawer: MainViewController, moduleProvider: ModuleProvider) {
        self.drawer = drawer
        self.moduleProvider = moduleProvider
    }
    
    var voidRouter: VoidRoutingLogic {
        return VoidRouter(moduleProvider: moduleProvider, drawer: drawer)
    }
    
    var exampleSceneRouter: ExampleSceneRoutingLogic {
        return ExampleSceneRouter(moduleProvider: moduleProvider, drawer: drawer)
    }
    
    var initialSceneRouter: InitialSceneRoutingLogic {
        return InitialSceneRouter(moduleProvider: moduleProvider, drawer: drawer)
    }
    
    var roomSceneRouter: RoomSceneRoutingLogic {
        return RoomSceneRouter(moduleProvider: moduleProvider, drawer: drawer)
    }
}
