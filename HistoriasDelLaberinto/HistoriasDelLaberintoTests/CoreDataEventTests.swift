import CoreData
import XCTest
@testable import HistoriasDelLaberinto

class CoreDataEventTests: XCTestCase, GameFilesLoader {
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    private lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LoadedGame", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
                                        
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    func testEvents() {
        let manager = EventFetcherManagerImpl(container: mockPersistentContainer)
        let events = getEvents().events
        XCTAssert(events.count > 0)
        
        for event in events {
            XCTAssert(manager.saveEvent(event))
        }
        
        var newEvents = [Event]()
        
        for event in events {
            if let newEvent = manager.getEvent(with: event.id) {
                newEvents.append(newEvent)
            } else {
                XCTFail()
            }
        }
        
        XCTAssert(newEvents.count == events.count)
    }
}
