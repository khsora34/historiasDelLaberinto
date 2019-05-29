enum DialogModels {
  // MARK: Use cases
  
  enum EventFetcher {
    struct Request {
        let id: String
    }
    enum Response {
        struct OkOutput {
            let characterName: String
            let characterImageUrl: String
            let message: String
            let nextStep: String?
        }
        enum Error {
            case eventNotFound, characterNotFound
        }
        case success(OkOutput)
        case error(Error)
    }
    struct ViewModel {
        let dialogConfigurator: DialogConfigurator?
    }
  }
}
