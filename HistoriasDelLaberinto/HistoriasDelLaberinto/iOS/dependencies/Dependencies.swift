import UIKit

class Dependencies {
    var eventsFetcherManager: EventsFetcherManager!
    var moduleProvider: ModuleProvider!
    
    lazy var routerProvider: RouterProvider = {
        guard let drawer = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else {
            fatalError("Can't find drawer.")
        }
        let routerProvider = RouterProvider(drawer: drawer, moduleProvider: moduleProvider)
        return routerProvider
    }()
    
    init() {
        eventsFetcherManager = createEventFetcher()
        createModuleProvider()
    }
    
    private func createModuleProvider() {
        moduleProvider = ModuleProvider()
        moduleProvider.routerProvider = routerProvider
        moduleProvider.eventsFetcherManager = eventsFetcherManager
    }
    
    private func createEventFetcher() -> EventsFetcherManager {
        let allEventDao = AllEventDaoImpl()
        return EventsFetcherManagerImpl(dao: allEventDao)
    }
}
