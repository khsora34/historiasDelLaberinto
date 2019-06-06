import Kingfisher

protocol ImageLoader: OnFinishedLoadingImageDelegate {
    var operations: [Int: ImageLoadingOperation] { get set }
    func loadImages(from imageUrls: [String])
    func removeImageCache()
}

extension ImageLoader {
    func loadImages(from imageUrls: [String]) {
        let urls = imageUrls.compactMap({ URL(string: $0) })
        var i = 0
        for url in urls {
            let operation = ImageLoadingOperation(identifier: i, url: url)
            operation.delegate = self
            operations[i] = operation
            i += 1
        }
        for operation in operations.values {
            operation.start()
        }
    }
    
    func removeImageCache() {
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
    
    func onFinished(id: Int) {
        operations[id] = nil
    }
}

class ImageLoadingOperation {
    let identifier: Int
    let url: URL
    
    weak var delegate: OnFinishedLoadingImageDelegate?
    
    init(identifier: Int, url: URL) {
        self.identifier = identifier
        self.url = url
    }
    
    func start() {
        let imageCompletion: (Result<RetrieveImageResult, KingfisherError>) -> Void = { [weak self] result in
            switch result {
            case .success(let success):
                print("❤️ Image with url \(success.source) loaded correctly.")
            case .failure(let failure):
                print("💔 Image didn't load correctly: \(failure.errorDescription ?? "")")
            }
            guard let self = self else { return }
            self.delegate?.onFinished(id: self.identifier)
        }
        
        if KingfisherManager.shared.retrieveImage(with: url, completionHandler: imageCompletion) == nil {
            delegate?.onFinished(id: identifier)
        }
    }
}

protocol OnFinishedLoadingImageDelegate: class {
    func onFinished(id: Int)
}
