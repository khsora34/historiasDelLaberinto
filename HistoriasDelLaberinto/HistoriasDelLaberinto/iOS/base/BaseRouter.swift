protocol RouterLogic {}

class BaseRouter: RouterLogic {
    let moduleProvider: ModuleProvider
    weak var drawer: MainViewController?
    
    init(moduleProvider: ModuleProvider, drawer: MainViewController) {
        self.moduleProvider = moduleProvider
        self.drawer = drawer
    }
}
