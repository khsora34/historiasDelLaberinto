import UIKit
import Kingfisher

class StatusView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "StatusView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        setup()
    }
    
    var ailment: StatusAilment? {
        didSet {
            ailmentLabel.text = ailment?.ailmentKey
            switch ailment {
            case .poison?:
                ailmentLabel.textColor = UIColor.green
            case .blindness?:
                ailmentLabel.textColor = UIColor.darkGray
            case .paralysis?:
                ailmentLabel.textColor = UIColor.yellow
            case .none:
                ailmentLabel.textColor = UIColor.clear
            }
        }
    }
    
    var characterChosen: CharacterChosen!
    weak var touchDelegate: DidTouchStatusDelegate?
    
    @IBOutlet var contentView: StatusView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ailmentLabel: UILabel!
    @IBOutlet private weak var actualhealthLabel: UILabel!
    @IBOutlet private weak var healthTitleLabel: UILabel!
    @IBOutlet private weak var maxHealthLabel: UILabel!
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var flashView: UIView!
    
    func configure(withModel model: StatusViewModel) {
        self.characterChosen = model.chosenCharacter
        self.nameLabel.text = model.name
        self.setHealth(currentHealth: model.actualHealth, maxHealth: model.maxHealth)
        self.ailment = model.ailment
        self.portraitImageView.setImage(from: model.imageSource)
        self.setBackground(shouldDisplayForEnemy: model.isEnemy)
        self.touchDelegate = model.delegate
    }
    
    func setHealth(currentHealth: Int, maxHealth: Int) {
        if currentHealth == 0 {
            actualhealthLabel.textColor = .red
        } else if Double(currentHealth) < Double(maxHealth) * 0.25 {
            actualhealthLabel.textColor = .yellow
        } else if currentHealth == maxHealth {
            actualhealthLabel.textColor = .green
            maxHealthLabel.textColor = .green
        } else {
            actualhealthLabel.textColor = .white
            maxHealthLabel.textColor = .white
        }
        actualhealthLabel.text = "\(currentHealth)"
        maxHealthLabel.text = "\(maxHealth)"
    }
    
    func setBackground(shouldDisplayForEnemy: Bool) {
        if shouldDisplayForEnemy {
            contentView.backgroundColor = UIColor.darkCoolBlue
        } else {
            contentView.backgroundColor = UIColor(red: 51/255, green: 220/255, blue: 1, alpha: 0.6)
        }
    }
    
    @IBAction func didTouchView(_ sender: Any) {
        guard let character = characterChosen else { return }
        touchDelegate?.didTouchStatus(character)
    }
}

extension StatusView {
    private func setup() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        setFonts()
        setColors()
        healthTitleLabel.text = Localizer.localizedString(key: "healthIndicator")
    }
    
    private func setFonts() {
        nameLabel.font = UIFont.systemFont(ofSize: 20.0)
        ailmentLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        healthTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        actualhealthLabel.font = UIFont.systemFont(ofSize: 17.0)
        maxHealthLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
    }
    
    private func setColors() {
        nameLabel.textColor = UIColor.white
        healthTitleLabel.textColor = UIColor.white
        actualhealthLabel.textColor = UIColor.white
        maxHealthLabel.textColor = UIColor.white
    }
}
