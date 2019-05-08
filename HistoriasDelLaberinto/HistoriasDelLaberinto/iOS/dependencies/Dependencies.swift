import UIKit

class Dependencies {
    var moduleProvider: ModuleProvider!
    
    lazy var routerProvider: RouterProvider = {
        guard let drawer = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else {
            fatalError("Can't find drawer.")
        }
        let routerProvider = RouterProvider(drawer: drawer, moduleProvider: moduleProvider)
        return routerProvider
    }()
    
    init() {
        createModuleProvider()
    }
    
    private func createModuleProvider() {
        moduleProvider = ModuleProvider()
        moduleProvider.routerProvider = routerProvider
    }
}
