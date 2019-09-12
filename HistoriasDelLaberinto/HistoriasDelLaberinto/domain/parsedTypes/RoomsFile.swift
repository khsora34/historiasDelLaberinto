struct RoomsFile: Decodable {
    let rooms: [String: Room]
}

typealias RoomsFileParser = YamlParser<RoomsFile>
