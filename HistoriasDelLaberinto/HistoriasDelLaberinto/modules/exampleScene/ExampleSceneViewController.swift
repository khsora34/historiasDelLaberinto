import UIKit

protocol ExampleSceneDisplayLogic: ViewControllerDisplay {
    func displaySomething(viewModel: ExampleSceneModels.Something.ViewModel)
    func displayNextStep(viewModel: ExampleSceneModels.DatabaseGetting.ViewModel)
}

class ExampleSceneViewController: BaseViewController {
    private var presenter: ExampleScenePresentationLogic? {
        return _presenter as? ExampleScenePresentationLogic
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var returnValueLabel: UILabel!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnValueLabel.isHidden = false
    }
    
    // MARK: Actions
    
    @IBAction func calculateValue(_ sender: Any) {
        presenter?.saveToDb()
        presenter?.getFromDb()
    }
}

extension ExampleSceneViewController: ExampleSceneDisplayLogic {
    
    func displaySomething(viewModel: ExampleSceneModels.Something.ViewModel) {
        print("Showing something")
        if let viewModelValue = viewModel.modeledValue {
            returnValueLabel.text = viewModelValue
            returnValueLabel.isHidden = false
        } else {
            returnValueLabel.isHidden = true
        }
    }
    
    func displayNextStep(viewModel: ExampleSceneModels.DatabaseGetting.ViewModel) {
        print("Showing next step")
        if let viewModelValue = viewModel.nextStep {
            returnValueLabel.text = viewModelValue
        } else {
            returnValueLabel.text = "Aquí no ha llegado nada."
        }
    }
}
