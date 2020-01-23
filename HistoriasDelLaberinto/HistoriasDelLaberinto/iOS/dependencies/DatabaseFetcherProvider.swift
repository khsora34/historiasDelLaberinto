class DatabaseFetcherProvider {
    var eventsFetcherManager: EventFetcherManager
    var itemsFetcher: ItemFetcher
    var charactersFetcher: CharacterFetcher
    var roomsFetcher: RoomFetcher
    var movementFetcher: MovementFetcher
    var localizedValueFetcher: LocalizedValueFetcher
    var variableFetcher: VariableFetcher

    init(eventsFetcherManager: EventFetcherManager, itemsFetcher: ItemFetcher, charactersFetcher: CharacterFetcher, roomsFetcher: RoomFetcher, movementFetcher: MovementFetcher, localizedValueFetcher: LocalizedValueFetcher, variableFetcher: VariableFetcher) {
        self.eventsFetcherManager = eventsFetcherManager
        self.itemsFetcher = itemsFetcher
        self.charactersFetcher = charactersFetcher
        self.roomsFetcher = roomsFetcher
        self.movementFetcher = movementFetcher
        self.localizedValueFetcher = localizedValueFetcher
        self.variableFetcher = variableFetcher
    }
}
