protocol ImageLoaderDelegate: class {
    func finishedLoadingImages(numberOfImagesLoaded: Int, source: ImageLoaderSource)
}

enum ImageLoaderSource {
    case newGame, loadGame
}
