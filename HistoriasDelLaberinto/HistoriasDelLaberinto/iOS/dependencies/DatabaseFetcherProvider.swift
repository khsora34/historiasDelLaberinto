class DatabaseFetcherProvider {
    var eventsFetcherManager: EventsFetcherManager
    var itemsFetcher: ItemsFetcher
    var charactersFetcher: CharactersFetcher
    var roomsFetcher: RoomsFetcher
    var protagonistFetcher: ProtagonistFetcher

    init(eventsFetcherManager: EventsFetcherManager, itemsFetcher: ItemsFetcher, charactersFetcher: CharactersFetcher, roomsFetcher: RoomsFetcher, protagonistFetcher: ProtagonistFetcher) {
        self.eventsFetcherManager = eventsFetcherManager
        self.itemsFetcher = itemsFetcher
        self.charactersFetcher = charactersFetcher
        self.roomsFetcher = roomsFetcher
        self.protagonistFetcher = protagonistFetcher
    }
}
