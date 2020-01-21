//
//  AppDelegate.swift
//  HistoriasDelLaberinto
//
//  Created by SYS_CIBER_ADMIN on 20/02/2019.
//  Copyright © 2019 SetonciOS. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dependencies: Dependencies!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let drawer = MainViewController()
        window?.rootViewController = drawer
        window?.makeKeyAndVisible()
        
        dependencies = Dependencies()
        
        let initialModule = dependencies.moduleProvider.initialSceneModule()
        let nav = UINavigationController(rootViewController: initialModule.viewController)
        
        setNavigationBarProperties()
        configureImageCache()
        
        drawer.setRoot(viewController: nav)
        
        return true
    }
    
    private func logFilesDirectory() {
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        print("😁😁😁😁 \(documentDirectoryURL)")
    }
    
    private func setNavigationBarProperties() {
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = .white
    }
    
    private func configureImageCache() {
        let cache = ImageCache.default
        cache.memoryStorage.config.expiration = .seconds(600)
        cache.diskStorage.config.expiration = .days(7)
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LoadedGame")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
