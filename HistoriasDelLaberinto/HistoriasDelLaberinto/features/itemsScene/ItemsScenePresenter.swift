protocol ItemsScenePresentationLogic: Presenter {
    func saveGame()
}

class ItemsScenePresenter: BasePresenter {
    var viewController: ItemsSceneDisplayLogic? {
        return _viewController as? ItemsSceneDisplayLogic
    }
    
    var interactor: ItemsSceneBusinessLogic? {
        return _interactor as? ItemsSceneBusinessLogic
    }
    
    var router: ItemsSceneRoutingLogic? {
        return _router as? ItemsSceneRoutingLogic
    }
    
    private var needsUpdate: Bool = false
    weak var updateDelegate: CharactersUpdateDelegate?
    
    private var charactersModels: [CharacterChosen: StatusViewModel] = [:]
    private var items: [String: Item] = [:]
    private var itemModels: [Int: ItemViewModel] = [:]
    var selectedItemTag: Int?
    
    private var protagonist: Protagonist
    private var partner: PlayableCharacter?
    
    init(protagonist: Protagonist, partner: PlayableCharacter? = nil) {
        self.protagonist = protagonist
        self.partner = partner
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showItems()
        buildCharacters()
    }
    
    private func showItems() {
        var i = 0
        for element in protagonist.items.keys {
            let request = ItemsScene.ItemGetter.Request(itemId: element)
            let response = interactor?.getItem(request: request)
            guard let item = response?.item else { continue }
            items[element] = item
            let model = ItemViewModel(id: element, name: item.name, description: item.description, itemType: ItemType(item: item), quantity: protagonist.items[element]!, imageUrl: item.imageUrl, tag: i, delegate: self)
            itemModels[i] = model
            i += 1
        }
        
        viewController?.buildItems(with: Array(itemModels.values))
    }
    
    private func buildCharacters() {
        let protagonistModel = StatusViewModel(chosenCharacter: .protagonist, name: protagonist.name, ailment: protagonist.currentStatusAilment, actualHealth: protagonist.currentHealthPoints, maxHealth: protagonist.maxHealthPoints, imageUrl: protagonist.portraitUrl, isEnemy: false, delegate: self)
        charactersModels[.protagonist] = protagonistModel
        var charactersForStatus: [StatusViewModel] = [protagonistModel]
        if let partner = partner {
            let partnerModel = StatusViewModel(chosenCharacter: .partner, name: partner.name, ailment: partner.currentStatusAilment, actualHealth: partner.currentHealthPoints, maxHealth: partner.maxHealthPoints, imageUrl: partner.portraitUrl, isEnemy: false, delegate: self)
            charactersForStatus.append(partnerModel)
            charactersModels[.partner] = partnerModel
        }
        viewController?.addCharactersStatus(charactersForStatus)
    }
}

extension ItemsScenePresenter: ItemsScenePresentationLogic {}

extension ItemsScenePresenter: ItemSelectedDelegate {
    func didSelectItem(isSelected: Bool, tag: Int) {
        if isSelected {
            selectedItemTag = tag
        } else {
            selectedItemTag = nil
        }
        deselectAllItems()
    }
    
    private func deselectAllItems() {
        for (_, model) in itemModels where model.tag != selectedItemTag {
            model.isSelected = false
            viewController?.updateItemView(model)
        }
    }
}

extension ItemsScenePresenter: DidTouchStatusDelegate {
    func didTouchStatus(_ characterChosen: CharacterChosen) {
        guard let tag = selectedItemTag, let selectedItemModel = itemModels[tag], let selectedItem = items[selectedItemModel.id], let consumable = selectedItem as? ConsumableItem else {
            selectedItemTag = nil
            deselectAllItems()
            return
        }
        switch characterChosen {
        case .enemy: break
        case .protagonist:
            guard let itemQuantity = protagonist.items[selectedItemModel.id], itemQuantity > 0, var protagonistModel = charactersModels[.protagonist] else { return }
            protagonist.currentHealthPoints += consumable.healthRecovered
            protagonistModel.actualHealth = protagonist.currentHealthPoints
            selectedItemModel.quantity = itemQuantity - 1
            updateItemModel(tag: tag, model: selectedItemModel)
            updateCharacterModel(chosen: .protagonist, model: protagonistModel)
            
        case .partner:
            guard let itemQuantity = protagonist.items[selectedItemModel.id], itemQuantity > 0, var characterModel = charactersModels[.partner] else { return }
            partner!.currentHealthPoints += consumable.healthRecovered
            characterModel.actualHealth = partner!.currentHealthPoints
            selectedItemModel.quantity = itemQuantity - 1
            updateItemModel(tag: tag, model: selectedItemModel)
            updateCharacterModel(chosen: .partner, model: characterModel)
        }
        needsUpdate = true
    }
    
    func saveGame() {
        guard needsUpdate else { return }
        let protaRequest = PauseMenuScene.ProtagonistUpdater.Request(protagonist: protagonist)
        interactor?.updateProtagonist(request: protaRequest)
        let partnerRequest = PauseMenuScene.CharacterUpdater.Request(partnerId: protagonist.partner, partner: partner)
        interactor?.updateCharacter(request: partnerRequest)
        updateDelegate?.update(with: protagonist, and: partner)
    }
    
    private func updateCharacterModel(chosen: CharacterChosen, model: StatusViewModel) {
        viewController?.updateStatusView(model)
        charactersModels[chosen] = model
    }
    
    private func updateItemModel(tag: Int, model: ItemViewModel) {
        viewController?.updateItemView(model)
        itemModels[tag] = model
        protagonist.items[model.id] = model.quantity > 0 ? model.quantity: nil
        
    }
}
