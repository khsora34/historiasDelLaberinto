import CoreData
import XCTest
@testable import HistoriasDelLaberinto

class CoreDataTests: XCTestCase, GameFilesLoader {
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
        manager.deleteAll()
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
    
    func testItems() {
        let manager = ItemFetcherImpl(container: mockPersistentContainer)
        manager.deleteAllItems()
        let itemsFile = getItems()
        var merged: [String: Item] = itemsFile.weapons
        for (key, value) in itemsFile.keyItems {
            merged[key] = value
        }
        
        for (key, value) in itemsFile.consumableItems {
            merged[key] = value
        }
        
        for (key, item) in merged {
            if !manager.saveItem(for: item, with: key) {
                XCTFail()
            }
        }
        
        var newItems = [Item]()
        
        for key in merged.keys {
            if let newItem = manager.getItem(with: key) {
                newItems.append(newItem)
            } else {
                XCTFail()
            }
        }
        
        XCTAssert(newItems.count == merged.count)
    }
    
    func testCharacters() {
        let manager = CharacterFetcherImpl(container: mockPersistentContainer)
        manager.deleteAllCharacters()
        let charactersFile = getCharacters()
        var merged: [String: GameCharacter] = charactersFile.playable
        for (key, value) in charactersFile.notPlayable {
            merged[key] = value
        }
        
        for (key, character) in merged {
            if !manager.saveCharacter(for: character, with: key) {
                XCTFail()
            }
        }
        
        var newChars = [GameCharacter]()
        
        for key in merged.keys {
            if let newChar = manager.getCharacter(with: key) {
                newChars.append(newChar)
            } else {
                XCTFail()
            }
        }
        
        XCTAssert(newChars.count == merged.count)
    }
    
    func testRooms() {
        let manager = RoomFetcherImpl(container: mockPersistentContainer)
        manager.deleteAllRooms()
        let rooms = getRooms().rooms
        
        for (key, room) in rooms {
            if !manager.saveRoom(for: room, with: key) {
                XCTFail()
            }
        }
        
        let newRooms = manager.getAllRooms()
        
        XCTAssert(newRooms.count == rooms.count)
    }
    
    func testStrings() {
        let manager = LocalizedValueFetcherImpl(container: mockPersistentContainer)
        manager.deleteAllTexts()
        let texts = getTexts()
        
        for (locale, localizedDict) in texts {
            for (key, value) in localizedDict where !manager.saveString(key: key, value: value, forLocale: locale) {
                XCTFail()
            }
        }
        
        let availableLanguages = manager.getAvailableLanguages()
        
        if Set(availableLanguages) != Set(texts.keys) {
            XCTFail()
        }
        
        var newTexts = [Locale: [String: String]]()
        
        for (locale, localizedDict) in texts {
            var newLocalized: [String: String] = [:]
            for (key, _) in localizedDict {
                newLocalized[key] = manager.getString(key: key, forLocale: locale)
            }
            newTexts[locale] = newLocalized
        }
        
        XCTAssert(newTexts.count == texts.count)
        
        for (locale, localizedDict) in texts {
            if localizedDict.count != newTexts[locale]?.count {
                XCTFail()
            }
        }
    }
    
    func testVariables() {
        let manager = VariableFetcherImpl(container: mockPersistentContainer)
        manager.deleteAllVariables()
        let variables = getVariables()
        
        for variable in variables where !manager.saveVariable(variable) {
            XCTFail()
        }
        
        var newVariables = [Variable]()
        
        for variable in variables {
            if let newVariable = manager.getVariable(with: variable.name) {
                newVariables.append(newVariable)
            } else {
                XCTFail()
            }
        }
        
        XCTAssert(newVariables.count == variables.count)
    }
}
