class ModuleProvider {
    var routerProvider: RouterProvider!
    var databaseFetcherProvider: DatabaseFetcherProvider!
    
    init() {}
    
    func exampleSceneModule() -> Module {
        return ExampleSceneModule(routerProvider: routerProvider, databaseFetcherProvider: databaseFetcherProvider)
    }
    
    func initialSceneModule() -> Module {
        return InitialSceneModule(routerProvider: routerProvider, databaseFetcherProvider: databaseFetcherProvider)
    }
    
    func roomSceneModule(room: Room) -> Module {
        return RoomSceneModule(room: room, routerProvider: routerProvider, databaseFetcherProvider: databaseFetcherProvider)
    }
    
    func movementSceneModule(room: Room) -> Module {
        return MovementSceneModule(room: room, routerProvider: routerProvider, databaseProvider: databaseFetcherProvider)
    }
    
    func pauseMenuSceneModuleModule() -> Module {
        return PauseMenuSceneModule(routerProvider: routerProvider, databaseProvider: databaseFetcherProvider)
    }
    
    func battleSceneModule(enemy: PlayableCharacter, backgroundImage: ImageSource, delegate: OnBattleFinishedDelegate) -> Module {
        return BattleSceneModule(enemy: enemy, backgroundImage: backgroundImage, delegate: delegate, routerProvider: routerProvider, databaseProvider: databaseFetcherProvider)
    }
    
    func itemsSceneModule(delegate: CharactersUpdateDelegate?) -> Module {
        return ItemsSceneModule(delegate: delegate, fetcherProvider: databaseFetcherProvider, routerProvider: routerProvider)
    }
    
    func languagesSelection() -> Module {
        return LanguageSelectionSceneModule(routerProvider: routerProvider, databaseFetcher: databaseFetcherProvider)
    }
}
