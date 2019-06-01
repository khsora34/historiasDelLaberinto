protocol IsEventAvailableCheckable {
    func checkEventAvailable(with id: String, eventFetcher: EventFetcherManager) -> Bool
}

extension IsEventAvailableCheckable {
    func checkEventAvailable(with id: String, eventFetcher: EventFetcherManager) -> Bool {
        return eventFetcher.getEvent(with: id) != nil
    }
}
