class DatabaseFetcherProvider {
    var eventsFetcherManager: EventFetcherManager
    var itemsFetcher: ItemFetcher
    var charactersFetcher: CharacterFetcher
    var roomsFetcher: RoomFetcher
    var protagonistFetcher: ProtagonistFetcher
    var movementFetcher: MovementFetcher

    init(eventsFetcherManager: EventFetcherManager, itemsFetcher: ItemFetcher, charactersFetcher: CharacterFetcher, roomsFetcher: RoomFetcher, protagonistFetcher: ProtagonistFetcher, movementFetcher: MovementFetcher) {
        self.eventsFetcherManager = eventsFetcherManager
        self.itemsFetcher = itemsFetcher
        self.charactersFetcher = charactersFetcher
        self.roomsFetcher = roomsFetcher
        self.protagonistFetcher = protagonistFetcher
        self.movementFetcher = movementFetcher
    }
}
