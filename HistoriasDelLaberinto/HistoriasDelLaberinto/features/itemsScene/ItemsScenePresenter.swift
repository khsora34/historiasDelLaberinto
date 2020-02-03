protocol ItemsScenePresentationLogic: Presenter {
    func saveCharactersStatus()
}

class ItemsScenePresenter: BasePresenter {
    var viewController: ItemsSceneDisplayLogic? { return _viewController as? ItemsSceneDisplayLogic }
    var interactor: ItemsSceneBusinessLogic? { return _interactor as? ItemsSceneBusinessLogic }
    private var router: ItemsSceneRoutingLogic? { return _router as? ItemsSceneRoutingLogic }
    
    private var hasChanged: Bool = false
    weak var updateDelegate: CharactersUpdateDelegate?
    
    private var protagonist: Protagonist
    private var partner: PlayableCharacter?
    private var charactersModels: [CharacterChosen: StatusViewModel] = [:]
    private var items: [String: Item] = [:]
    private var itemModels: [Int: ItemViewModel] = [:]
    var selectedItemTag: Int?
    
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
        for (key, value) in protagonist.items {
            let request = ItemsScene.ItemGetter.Request(itemId: key)
            let response = interactor?.getItem(request: request)
            guard let item = response?.item, let type = ItemType(item: item) else { continue }
            items[key] = item
            let model = ItemViewModel(id: key, item: item, itemType: type, quantity: value, imageSource: item.imageSource, tag: i, delegate: self)
            itemModels[i] = model
            i += 1
        }
        
        viewController?.buildItems(with: Array(itemModels.values))
    }
    
    private func buildCharacters() {
        let protagonistModel = StatusViewModel(chosenCharacter: .protagonist, name: protagonist.name, ailment: protagonist.currentStatusAilment, actualHealth: protagonist.currentHealthPoints, maxHealth: protagonist.maxHealthPoints, imageSource: protagonist.portraitSource, isEnemy: false, delegate: self)
        charactersModels[.protagonist] = protagonistModel
        var charactersForStatus: [StatusViewModel] = [protagonistModel]
        if let partner = partner {
            let partnerModel = StatusViewModel(chosenCharacter: .partner, name: partner.name, ailment: partner.currentStatusAilment, actualHealth: partner.currentHealthPoints, maxHealth: partner.maxHealthPoints, imageSource: partner.portraitSource, isEnemy: false, delegate: self)
            charactersForStatus.append(partnerModel)
            charactersModels[.partner] = partnerModel
        }
        viewController?.addCharactersStatus(charactersForStatus)
    }
}

extension ItemsScenePresenter: ItemsScenePresentationLogic {
    func saveCharactersStatus() {
        guard hasChanged else { return }
        GameSession.setProtagonist(protagonist)
        if let partner = partner, let partnerId = protagonist.partner {
            GameSession.addPartner(partner, withId: partnerId)
        }
        updateDelegate?.update(with: protagonist, and: partner)
    }
}

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
        hasChanged = true
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
