import UIKit

extension UIStackView {
    func createButtonsInColumns(names: [String], action: Selector, for view: Any, numberOfColumns: Int = 2) {
        func createButton(name: String, tag: Int) -> UIButton {
            let button = ConfigurableButton(type: .custom)
            button.setupStyle(ButtonStyle.defaultButtonStyle)
            button.setTitle(name, for: .normal)
            button.tag = tag
            button.addTarget(view, action: action, for: .touchUpInside)
            return button
        }
        
        addViewsInColumns(
            names.enumerated().map({createButton(name: $1, tag: $0)}),
            numberOfColumns: numberOfColumns)
    }
    
    func addViewsInColumns(_ views: [UIView], numberOfColumns: Int = 2) {
        for i in 0...((views.count-1)/numberOfColumns) {
            let buttonStackView: UIStackView
            let endRange: Int = i == views.count/numberOfColumns ?
                (numberOfColumns*i)+(views.count-1-(views.count/numberOfColumns)*numberOfColumns):
                (numberOfColumns*i)+(numberOfColumns-1)
            var newButtons: [UIView] = []
            for j in numberOfColumns*i...endRange {
                newButtons.append(views[j])
            }
            buttonStackView = UIStackView(arrangedSubviews: newButtons)
            
            buttonStackView.axis = .horizontal
            buttonStackView.distribution = .fillEqually
            buttonStackView.alignment = .center
            buttonStackView.spacing = 20
            self.addArrangedSubview(buttonStackView)
        }
    }
}
