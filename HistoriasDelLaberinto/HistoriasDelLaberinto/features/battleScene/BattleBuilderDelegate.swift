protocol BattleBuilderDelegate: class {
    var imageUrl: String { get }
    func onBattleFinished()
}
