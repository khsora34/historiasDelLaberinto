protocol DialogLauncher: NextDialogHandler {
    var dialog: DialogDisplayLogic? { get set }
    var viewController: BattleSceneDisplayLogic? { get }
    func present(_ dialog: DialogDisplayLogic)
}

extension DialogLauncher {
    func showDialog(with configurator: DialogConfigurator) {
        guard dialog == nil else {
            dialog?.setNextConfigurator(configurator)
            
            if viewController?.presentedViewController == nil {
                present(dialog!)
            }
            return
        }
        dialog = Dialog.createDialog(configurator, delegate: self)
        present(dialog!)
    }
}
