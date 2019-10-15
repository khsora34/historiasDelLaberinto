import UIKit

extension UIStackView {
    func setButtonsInColumns(names: [String], action: Selector, for view: Any, numberOfColumns: Int = 2, fixedHeight: Bool = false) {
        func createButton(name: String, tag: Int) -> UIButton {
            let button = ConfigurableButton(type: .custom)
            button.setupStyle(ButtonStyle.defaultButtonStyle)
            button.setTitle(name, for: .normal)
            button.tag = tag
            button.addTarget(view, action: action, for: .touchUpInside)
            return button
        }
        for i in 0...((names.count-1)/numberOfColumns) {
            let buttonStackView: UIStackView
            let endRange: Int = i == names.count/numberOfColumns ?
                (numberOfColumns*i)+(names.count-1-(names.count/numberOfColumns)*numberOfColumns):
                (numberOfColumns*i)+(numberOfColumns-1)
            var buttons: [UIButton] = []
            for j in numberOfColumns*i...endRange {
                buttons.append(createButton(name: names[j], tag: j))
            }
            buttonStackView = UIStackView(arrangedSubviews: buttons)
            
            buttonStackView.axis = .horizontal
            buttonStackView.distribution = .fillEqually
            buttonStackView.alignment = .center
            buttonStackView.spacing = 20
            if fixedHeight {
                NSLayoutConstraint(item: buttonStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60).isActive = true
            }
            self.addArrangedSubview(buttonStackView)
        }
    }
}
