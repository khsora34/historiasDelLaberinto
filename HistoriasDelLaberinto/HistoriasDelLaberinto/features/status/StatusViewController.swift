import UIKit
import Kingfisher

class StatusViewController: UIView {
    
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
    
    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }
    
    var actualHealth: Int? {
        get {
            return Int(actualhealthLabel.text ?? "")
        }
        set {
            actualhealthLabel.text = "\(newValue ?? -1)"
        }
    }
    
    var maxHealth: Int? {
        get {
            return Int(maxHealthLabel.text ?? "")
        }
        set {
            maxHealthLabel.text = "\(newValue ?? -1)"
        }
    }
    
    var ailment: StatusAilment? {
        get {
            switch ailmentLabel.text {
            case "Veneno":
                return .poisoned
            case "Parálisis":
                return .paralyzed
            case "Ceguera":
                return .blind
            default:
                return nil
            }
        }
        set {
            switch newValue {
            case .poisoned?:
                ailmentLabel.text = "Veneno"
                ailmentLabel.textColor = UIColor.green
            case .blind?:
                ailmentLabel.text = "Ceguera"
                ailmentLabel.textColor = UIColor.darkGray
            case .paralyzed?:
                ailmentLabel.text = "Parálisis"
                ailmentLabel.textColor = UIColor.yellow
            case .none:
                ailmentLabel.text = ""
                ailmentLabel.textColor = UIColor.clear
            }
        }
    }
    
    var didTouchView: (() -> Void)?

    @IBOutlet var contentView: StatusViewController!
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ailmentLabel: UILabel!
    @IBOutlet private weak var actualTitleLabel: UILabel!
    @IBOutlet private weak var actualhealthLabel: UILabel!
    @IBOutlet private weak var maxTitleLabel: UILabel!
    @IBOutlet private weak var maxHealthLabel: UILabel!
    
    func setImage(with imageUrl: String) {
        portraitImageView.kf.setImage(with: URL(string: imageUrl))
    }
    
    @IBAction func didTouchView(_ sender: Any) {
        didTouchView?()
    }
}

extension StatusViewController {
    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = UIColor(red: 51/255, green: 220/255, blue: 1, alpha: 0.6)
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        setFonts()
        setColors()
        actualTitleLabel.text = "Vida actual"
        maxTitleLabel.text = "Vida máxima"
    }
    
    private func setFonts() {
        nameLabel.font = UIFont.systemFont(ofSize: 20.0)
        ailmentLabel.font = UIFont.systemFont(ofSize: 17.0)
        actualTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        actualhealthLabel.font = UIFont.systemFont(ofSize: 17.0)
        maxTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        maxHealthLabel.font = UIFont.systemFont(ofSize: 17.0)
    }
    
    private func setColors() {
        nameLabel.textColor = UIColor.white
        actualTitleLabel.textColor = UIColor.white
        actualhealthLabel.textColor = UIColor.white
        maxTitleLabel.textColor = UIColor.white
        maxHealthLabel.textColor = UIColor.white
    }
}