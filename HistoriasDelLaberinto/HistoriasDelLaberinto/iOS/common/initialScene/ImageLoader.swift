import Kingfisher

protocol ImageLoader {
    func loadImages(from imageUrls: [String])
    func removeCache()
}

extension ImageLoader {
    func loadImages(from imageUrls: [String]) {
        let urls = imageUrls.compactMap({ URL(string: $0) })
        
        for url in urls {
            KingfisherManager.shared.retrieveImage(with: url, completionHandler: nil)
        }
    }
    
    func removeCache() {
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
}
