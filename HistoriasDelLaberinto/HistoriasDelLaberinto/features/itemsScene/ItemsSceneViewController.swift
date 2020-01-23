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
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            presenter?.saveCharactersStatus()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localizer.localizedString(key: "itemsViewTitle")
        backgroundView.setColors([.red, .yellow, .orange])
        backgroundView.startAnimation()
        conditionView.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
    }
}

extension ItemsSceneViewController: ItemsSceneDisplayLogic {    
    func addCharactersStatus(_ models: [StatusViewModel]) {
        for model in models {
            let statusView = StatusView(frame: .zero)
            statusView.configure(withModel: model)
            statusView.isUserInteractionEnabled = true
            statusStackView.addArrangedSubview(statusView)
        }
        
        if #available(iOS 11, *) {
            let iphoneXView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: view.safeAreaInsets.bottom)))
            iphoneXView.backgroundColor = .clear
            statusStackView.addArrangedSubview(iphoneXView)
        }
    }
    
    func buildItems(with models: [ItemViewModel]) {
        for model in models {
            let view = ItemView(frame: .zero)
            view.configure(withModel: model)
            itemsStackView.addArrangedSubview(view)
        }
    }
    
    func updateStatusView(_ model: StatusViewModel) {
        if let view = statusStackView.arrangedSubviews.first(where: { ($0 as? StatusView)?.characterChosen == model.chosenCharacter }) as? StatusView {
            view.configure(withModel: model)
            addBlinkAnimation(to: view.flashView, withAutoreverse: true)
        }
    }
    
    func updateItemView(_ model: ItemViewModel) {
        guard let view = itemsStackView.arrangedSubviews.first(where: { $0.tag == model.tag }) as? ItemView else { return }
        guard model.quantity > 0 else {
            UIView.animate(withDuration: 0.1) {
                view.isHidden = true
            }
            itemsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
            return
        }
        view.configure(withModel: model)
    }
    
    private func addBlinkAnimation(to view: UIView, withAutoreverse: Bool) {
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 0
        anim.toValue = 0.7
        anim.duration = 0.2
        anim.timingFunction = CAMediaTimingFunction(name: .linear)
        anim.autoreverses = true
        anim.repeatCount = 1
        view.layer.add(anim, forKey: "opacity")
    }
}
