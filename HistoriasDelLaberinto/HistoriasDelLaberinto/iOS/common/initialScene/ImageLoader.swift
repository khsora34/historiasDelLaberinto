import Kingfisher

protocol ImageLoader: OnFinishedLoadingImageDelegate, ImageRemover {
    var operations: [Int: ImageLoadingOperation] { get set }
    var successfulOperations: Int { get set }
    func loadImages(from imageUrls: [ImageSource])
    func removeImageCache()
}

extension ImageLoader {
    func loadImages(from imageUrls: [ImageSource]) {
        let urls = imageUrls.compactMap { (source) -> URL? in
            guard case let .remote(stringUrl) = source else { return nil }
            return URL(string: stringUrl)
        }
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
    
    func onFinished(id: Int, success: Bool) {
        operations[id] = nil
        if success {
            successfulOperations += 1
        }
    }
}

protocol ImageRemover {
    func removeImageCache()
}

extension ImageRemover {
    func removeImageCache() {
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
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
            var didLoad = false
            switch result {
            case .success(let success):
                didLoad = true
                print("❤️ Image with url \(success.source) loaded correctly.")
            case .failure(let failure):
                print("💔 Image didn't load correctly: \(failure.errorDescription ?? "")")
            }
            guard let self = self else { return }
            self.delegate?.onFinished(id: self.identifier, success: didLoad)
        }
        
        if KingfisherManager.shared.retrieveImage(with: url, completionHandler: imageCompletion) == nil {
            delegate?.onFinished(id: identifier, success: true)
        }
    }
}

protocol OnFinishedLoadingImageDelegate: class {
    func onFinished(id: Int, success: Bool)
}
