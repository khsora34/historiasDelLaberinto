import UIKit
import Kingfisher

extension UIImageView {
    func setImage(for source: ImageSource) {
        if case let .local(path) = source {
            self.image = UIImage(contentsOfFile: path)
        } else if case let .remote(stringUrl) = source {
            self.kf.setImage(with: URL(string: stringUrl))
        }
    }
}
