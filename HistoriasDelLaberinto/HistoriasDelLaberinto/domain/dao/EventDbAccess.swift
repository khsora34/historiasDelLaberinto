import CoreData.NSManagedObject

protocol EventDBAccess {
    associatedtype T: NSManagedObject
    func get(id: String) -> T?
    func save(event: T)
}
