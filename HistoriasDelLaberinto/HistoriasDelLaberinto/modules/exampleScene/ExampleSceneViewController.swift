import UIKit

protocol ExampleSceneDisplayLogic: ViewControllerDisplay {
    func displaySomething(viewModel: ExampleScene.Something.ViewModel)
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
    }
    
    // MARK: Actions
    
    @IBAction func calculateValue(_ sender: Any) {
        presenter?.calculateValueWith(string: textField.text)
    }
}

extension ExampleSceneViewController: ExampleSceneDisplayLogic {
    
    func displaySomething(viewModel: ExampleScene.Something.ViewModel) {
        print("Showing something")
        if let viewModelValue = viewModel.modeledValue {
            returnValueLabel.text = viewModelValue
            returnValueLabel.isHidden = false
        } else {
            returnValueLabel.isHidden = true
        }
        
    }
}
