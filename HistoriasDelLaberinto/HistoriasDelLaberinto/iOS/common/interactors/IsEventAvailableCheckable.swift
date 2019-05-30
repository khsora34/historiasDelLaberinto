protocol IsEventAvailableCheckable {
    func checkEventAvailable(with id: String, eventFetcher: EventsFetcherManager) -> Bool
}

extension IsEventAvailableCheckable {
    func checkEventAvailable(with id: String, eventFetcher: EventsFetcherManager) -> Bool {
        return eventFetcher.getEvent(with: id) != nil
    }
}
