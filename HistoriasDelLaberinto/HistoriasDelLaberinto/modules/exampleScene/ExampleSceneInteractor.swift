protocol ExampleSceneBusinessLogic: BusinessLogic {
    func doSomething(request: ExampleScene.Something.Request) -> ExampleScene.Something.Response
    
}

class ExampleSceneInteractor: ExampleSceneBusinessLogic {
    // MARK: Do something
    
    func doSomething(request: ExampleScene.Something.Request) -> ExampleScene.Something.Response {
        let worker = ExampleScenePerformer()
        let result = worker.doSomeWork(entry: request.input)
        
        return ExampleScene.Something.Response(output: result)
    }
}
