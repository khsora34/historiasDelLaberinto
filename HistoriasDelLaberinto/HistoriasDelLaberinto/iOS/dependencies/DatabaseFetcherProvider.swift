class DatabaseFetcherProvider {
    var eventsFetcherManager: EventFetcherManager
    var itemsFetcher: ItemFetcher
    var charactersFetcher: CharacterFetcher
    var roomsFetcher: RoomFetcher
    var protagonistFetcher: ProtagonistFetcher

    init(eventsFetcherManager: EventFetcherManager, itemsFetcher: ItemFetcher, charactersFetcher: CharacterFetcher, roomsFetcher: RoomFetcher, protagonistFetcher: ProtagonistFetcher) {
        self.eventsFetcherManager = eventsFetcherManager
        self.itemsFetcher = itemsFetcher
        self.charactersFetcher = charactersFetcher
        self.roomsFetcher = roomsFetcher
        self.protagonistFetcher = protagonistFetcher
    }
}
