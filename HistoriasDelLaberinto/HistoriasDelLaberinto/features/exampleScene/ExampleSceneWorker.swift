class ExampleSceneWorker {
    func doSomeWork(entry: String?) -> String? {
        return entry != nil ? entry! + "!": nil
    }
}
