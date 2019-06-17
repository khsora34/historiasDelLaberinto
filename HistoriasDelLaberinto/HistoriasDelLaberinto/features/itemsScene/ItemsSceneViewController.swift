import UIKit
import Pastel

protocol ItemsSceneDisplayLogic: ViewControllerDisplay {
    func addCharactersStatus(_ models: [StatusViewModel])
    func buildItems(with models: [ItemViewModel])
    func updateStatusView(_ model: StatusViewModel)
    func updateItemView(_ model: ItemViewModel)
}

class ItemsSceneViewController: BaseViewController {
    
    private var presenter: ItemsScenePresentationLogic? {
        return _presenter as? ItemsScenePresentationLogic
    }
    
    @IBOutlet weak var backgroundView: PastelView!
    @IBOutlet weak var conditionView: UIView!
    @IBOutlet weak var itemsStackView: UIStackView!
    @IBOutlet weak var statusStackView: UIStackView!
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Inventario"
        
        backgroundView.setColors([.red, .yellow, .orange])
        backgroundView.startAnimation()
        conditionView.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
    }
}

extension ItemsSceneViewController: ItemsSceneDisplayLogic {
    func addCharactersStatus(_ models: [StatusViewModel]) {
        for model in models {
            let statusView = StatusViewController(frame: CGRect.zero)
            model.configure(view: statusView)
            statusView.isUserInteractionEnabled = true
            statusStackView.addArrangedSubview(statusView)
        }
    }
    
    func buildItems(with models: [ItemViewModel]) {
        for model in models {
            let view = ItemView(model: model, frame: CGRect(origin: .zero, size: CGSize(width: 0, height: 70)))
            itemsStackView.addArrangedSubview(view)
        }
    }
    
    func updateStatusView(_ model: StatusViewModel) {
        if let view = statusStackView.arrangedSubviews.filter({ ($0 as? StatusViewController)?.characterChosen == model.chosenCharacter }).first as? StatusViewController {
            model.configure(view: view)
        }
    }
    
    func updateItemView(_ model: ItemViewModel) {
        guard let view = itemsStackView.arrangedSubviews.filter({ $0.tag == model.tag }).first as? ItemView else { return }
        guard model.quantity > 0 else {
            UIView.animate(withDuration: 0.1) {
                view.isHidden = true
            }
            itemsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
            return
        }
        model.configure(view: view)
    }
}
