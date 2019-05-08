import UIKit

class ViewCreator {
    static func createFrom(storyboardName: String, forController controller: String) -> BaseViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let newController = storyboard.instantiateViewController(withIdentifier: controller) as? BaseViewController else {
            fatalError("The controller is not a BaseViewController.")
        }
 
        return newController
    }
}
