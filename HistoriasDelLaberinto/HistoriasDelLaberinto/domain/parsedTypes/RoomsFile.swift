struct RoomsFile: Codable {
    let rooms: [String: Room]
}

typealias RoomsFileParser = YamlParser<RoomsFile>
