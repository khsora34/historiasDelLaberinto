import UIKit

protocol InitialSceneDisplayLogic: ViewControllerDisplay {
    func setLabelText(with text: String)
}

class InitialSceneViewController: BaseViewController {
    private var presenter: InitialScenePresentationLogic? {
        return _presenter as? InitialScenePresentationLogic
    }
    
    @IBOutlet weak var loadFilesButton: UIButton!
    @IBOutlet weak var deleteFilesButton: UIButton!
    
    // MARK: Setup
    
    private func setup() {
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func didLoadFilesButtonTap(_ sender: Any) {
        presenter?.loadFiles()
    }
    @IBAction func didDeleteFilesButtonTap(_ sender: Any) {
        presenter?.deleteFiles()
    }
    
    @IBAction func didTapNextViewButton(_ sender: Any) {
        presenter?.goToExampleView()
    }
}

extension InitialSceneViewController: InitialSceneDisplayLogic {
    func setLabelText(with text: String) {
    }
}
