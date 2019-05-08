protocol ExampleSceneWorker {
    func doSomeWork(entry: String?) -> String?
}

class ExampleScenePerformer {}

extension ExampleScenePerformer: ExampleSceneWorker {
    func doSomeWork(entry: String?) -> String? {
        return entry != nil ? entry! + "!": nil
    }
}
