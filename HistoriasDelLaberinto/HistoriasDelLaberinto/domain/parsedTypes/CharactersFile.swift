struct CharactersFile: Codable {
    let playable: [String: PlayableCharacter]
    let notPlayable: [String: NotPlayableCharacter]
}

typealias CharactersFileParser = YamlParser<CharactersFile>
