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
    @IBOutlet weak var navigateButton: UIButton!
    @IBOutlet weak var toNewViewButton: UIButton!
    
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
    
    @IBAction func navigateToPlace(_ sender: Any) {
        presenter?.navigateToPlace()
    }
    
    @IBAction func toNewViewAction(_ sender: Any) {
        presenter?.navigateToNewPlace()
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
