import UIKit

extension UIStackView {
    func setButtonsInColumns(names: [String], action: Selector, for view: ButtonSelectableView, numberOfColumns: Int = 2, fixedHeight: Bool = false) {
        for i in 0...((names.count-1)/numberOfColumns) {
            let buttonStackView: UIStackView
            
            if i == names.count/numberOfColumns {
                var buttons: [UIButton] = []
                for j in numberOfColumns*i...numberOfColumns*(names.count - (names.count/numberOfColumns)*numberOfColumns) {
                    let button = RoundedButton(type: .custom)
                    button.setTitle(names[(j)], for: .normal)
                    button.tag = j
                    button.addTarget(view, action: action, for: .touchUpInside)
                    buttons.append(button)
                }
                buttonStackView = UIStackView(arrangedSubviews: buttons)
            } else {
                var buttons: [UIButton] = []
                for j in numberOfColumns*i...(numberOfColumns*i)+(numberOfColumns-1) {
                    let button = RoundedButton(type: .custom)
                    button.setTitle(names[j], for: .normal)
                    button.tag = j
                    button.addTarget(view, action: action, for: .touchUpInside)
                    buttons.append(button)
                }
                
                buttonStackView = UIStackView(arrangedSubviews: buttons)
            }
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
