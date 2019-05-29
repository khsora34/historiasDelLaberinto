enum DialogModels {
  // MARK: Use cases
  
  enum EventFetcher {
    struct Request {
        let id: String
    }
    enum Response {
        enum Error {
            case eventNotFound, characterNotFound
        }
        case success(characterName: String, characterImageUrl: String, message: String)
        case error(Error)
    }
    struct ViewModel {
        let dialogConfigurator: DialogConfigurator?
    }
  }
}
