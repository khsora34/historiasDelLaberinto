import UIKit
import Kingfisher

extension UIImageView {
    func setImage(for source: ImageSource, completion: ((Bool, CGSize) -> Void)? = nil) {
        if case let .local(file) = source {
            if
                let path = Bundle.main.path(forResource: file, ofType: nil, inDirectory: "loadedGame/images"),
                let image = UIImage(contentsOfFile: path) {
                self.image = image
                completion?(true, image.size)
            } else {
                completion?(false, .zero)
            }
            
        } else if case let .remote(stringUrl) = source {
            self.kf.setImage(with: URL(string: stringUrl)) { (result: (Result<RetrieveImageResult, KingfisherError>)) -> Void in
                switch result {
                case .success(let result):
                    completion?(true, result.image.size)
                case .failure:
                    completion?(false, .zero)
                }
            }
        }
    }
}
