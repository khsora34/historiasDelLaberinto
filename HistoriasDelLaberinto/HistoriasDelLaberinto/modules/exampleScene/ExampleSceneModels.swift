enum ExampleSceneModels {
    // MARK: Use cases
    
    enum Something {
        struct Request {
            let input: String?
        }
        struct Response {
            let output: String?
        }
        struct ViewModel {
            let modeledValue: String?
        }
    }
    
    enum DatabaseSaving {
        struct Request {
            let id: String
            let event: Event
        }
    }
    
    enum DialogAvailable {
        struct Request {
            let id: String
        }
        enum Response {
            struct Error {
                let reason: String
            }
            case ok
            case error(Error)
        }
        struct ViewModel {
            let nextStep: String?
        }
    }
    
    enum DatabaseGetting {
        struct Request {
            let id: String
        }
        struct Response {
            let event: Event?
        }
        struct ViewModel {
            let nextStep: String?
        }
    }
}

struct ExampleScenePresenterInput {
    
}
