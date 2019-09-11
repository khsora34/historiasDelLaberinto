import UIKit

protocol DialogLauncher: NextDialogHandler {
    var dialog: DialogDisplayLogic? { get set }
    var dialogRouter: DialogRouter? { get }
}

extension DialogLauncher {
    func showDialog(with configurator: DialogConfigurator) {
        if dialog == nil {
            dialog = Dialog.createDialog(configurator, delegate: self)
            dialogRouter?.present(dialog!, animated: true)
        } else {
            dialog?.setNextConfigurator(configurator)
        }
    }
    
    func hideDialog() {
        dialog = nil
        dialogRouter?.dismiss(animated: true)
    }
}

protocol DialogRouter {
    func present(_ controller: UIViewController, animated: Bool)
    func dismiss(animated: Bool)
}
