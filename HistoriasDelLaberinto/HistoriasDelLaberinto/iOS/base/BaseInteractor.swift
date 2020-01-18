class BaseInteractor: BusinessLogic {
    internal var localizedStringAccess: LocalizedValueFetcher
    
    init(localizedStringAccess: LocalizedValueFetcher) {
        self.localizedStringAccess = localizedStringAccess
    }
}

protocol BusinessLogic {}
