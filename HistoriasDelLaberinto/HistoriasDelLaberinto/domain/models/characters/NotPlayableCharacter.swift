struct NotPlayableCharacter: GameCharacter, ImageRepresentable {
    let name: String
    let imageUrl: String
}

typealias NotPlayableCharacterParser = YamlParser<NotPlayableCharacter>
