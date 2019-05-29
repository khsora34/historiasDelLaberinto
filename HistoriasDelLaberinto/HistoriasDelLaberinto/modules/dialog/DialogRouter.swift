import UIKit

protocol DialogRoutingLogic: RouterLogic {
    func dismiss()
}

class DialogRouter: BaseRouter, DialogRoutingLogic {
    func dismiss() {
        drawer?.dismiss(animated: true, completion: nil)
    }
}
