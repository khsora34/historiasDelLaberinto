import UIKit

class Dependencies {
    var moduleProvider: ModuleProvider!
    var databaseFetcherProvider: DatabaseFetcherProvider!
    
    lazy var routerProvider: RouterProvider = {
        guard let drawer = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else {
            fatalError("Can't find drawer.")
        }
        let routerProvider = RouterProvider(drawer: drawer, moduleProvider: moduleProvider)
        return routerProvider
    }()
    
    init() {
        databaseFetcherProvider = createDatabaseFetcherProvider()
        createModuleProvider()
    }
    
    private func createModuleProvider() {
        moduleProvider = ModuleProvider()
        moduleProvider.routerProvider = routerProvider
        moduleProvider.databaseFetcherProvider = databaseFetcherProvider
    }
    
    private func createDatabaseFetcherProvider() -> DatabaseFetcherProvider {
        return DatabaseFetcherProvider(eventsFetcherManager: EventFetcherManagerImpl(), itemsFetcher: ItemFetcherImpl(), charactersFetcher: CharacterFetcherImpl(), roomsFetcher: RoomFetcherImpl(), movementFetcher: MovementFetcherImpl())
    }
}
