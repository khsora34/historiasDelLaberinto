//
//  ModelParsersTests.swift
//  HistoriasDelLaberintoTests
//
//  Created by SYS_CIBER_ADMIN on 11/04/2019.
//  Copyright © 2019 SetonciOS. All rights reserved.
//

import XCTest
@testable import HistoriasDelLaberinto

class ModelParsersTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testParseProtagonistModel() {
        guard let path = Bundle.main.path(forResource: "prota", ofType: "yml", inDirectory: "loadedGame") else {
            XCTFail("Couldn't find prota.yml in loadedGame directory.")
            return
        }
        
        guard let fileContent = try? String(contentsOfFile: path) else {
            XCTFail("Unable to read the content of the file in path \(path).")
            return
        }
        
        let parser = ProtagonistParser()
        guard let protagonist = parser.serialize(fileContent) else {
            XCTFail("Failed to parse characters body.")
            return
        }
        print(protagonist)
    }
    
    func testCharactersModel() {
        guard let path = Bundle.main.path(forResource: "characters", ofType: "yml", inDirectory: "loadedGame") else {
            XCTFail("Couldn't find prota.yml in loadedGame directory.")
            return
        }
        
        guard let fileContent = try? String(contentsOfFile: path) else {
            XCTFail("Unable to read the content of the file in path \(path).")
            return
        }
        
        let parser = CharactersFileParser()
        guard let characters = parser.serialize(fileContent), !characters.playable.isEmpty, !characters.notPlayable.isEmpty else {
            XCTFail("Failed to parse characters body.")
            return
        }
        print(characters)
    }
    
    func testItemsModel() {
        guard let path = Bundle.main.path(forResource: "items", ofType: "yml", inDirectory: "loadedGame") else {
            XCTFail("Couldn't find prota.yml in loadedGame directory.")
            return
        }
        
        guard let fileContent = try? String(contentsOfFile: path) else {
            XCTFail("Unable to read the content of the file in path \(path).")
            return
        }
        
        let parser = ItemsFileParser()
        guard let items = parser.serialize(fileContent), !items.consumableItems.isEmpty, !items.keyItems.isEmpty, !items.weapons.isEmpty else {
            XCTFail("Failed parsing items file.")
            return
        }
        print(items)
    }
    
    func testEventsModel() {
        guard let path = Bundle.main.path(forResource: "events", ofType: "yml", inDirectory: "loadedGame") else {
            XCTFail("Couldn't find prota.yml in loadedGame directory.")
            return
        }
        
        guard let fileContent = try? String(contentsOfFile: path) else {
            XCTFail("Unable to read the content of the file in path \(path).")
            return
        }
        
        let parser = EventParser()
        guard let events = parser.serialize(fileContent), !events.events.isEmpty else {
            XCTFail("Unable to serialize the events file.")
            return
        }
        print(events)
    }
    
    func testRoomsProtagonistModel() {
        guard let path = Bundle.main.path(forResource: "rooms", ofType: "yml", inDirectory: "loadedGame") else {
            XCTFail("Couldn't find rooms.yml in loadedGame directory.")
            return
        }
        
        guard let fileContent = try? String(contentsOfFile: path) else {
            XCTFail("Unable to read the content of the file in path \(path).")
            return
        }
        
        let parser = RoomsFileParser()
        guard let rooms = parser.serialize(fileContent), !rooms.rooms.isEmpty else {
            XCTFail("Failed to parse characters body.")
            return
        }
        print(rooms)
    }
    
    func testTexts() {
        var texts: [String: [String: String]] = [:]
        
        let availableLanguagePaths: [String] = Bundle.main.paths(forResourcesOfType: "strings", inDirectory: "loadedGame/texts")
        XCTAssert(availableLanguagePaths.count > 0)
        
        for path in availableLanguagePaths {
            guard let langDictionary = NSDictionary(contentsOfFile: path) else {
                XCTFail("Unable to load file in path \(path).")
                continue
            }
            guard let literals = langDictionary as? [String: String] else {
                XCTFail("Unable to parse dictionary as [String: String]")
                continue
            }
            let startIndex: String.Index = path.index(path.endIndex, offsetBy: -10)
            let endIndex: String.Index = path.index(path.endIndex, offsetBy: -8)
            
            XCTAssert(startIndex < endIndex)
            
            let languageCode: String = String(path[startIndex..<endIndex])
            texts[languageCode] = literals
        }
        print(texts)
    }
    
    func testVariablesModel() {
        guard let path = Bundle.main.path(forResource: "variables", ofType: "yml", inDirectory: "loadedGame") else {
            XCTFail("Couldn't find variables.yml in loadedGame directory.")
            return
        }
        
        guard let fileContent = try? String(contentsOfFile: path) else {
            XCTFail("Unable to read the content of the file in path \(path).")
            return
        }
        
        let parser = VariablesFileParser()
        guard let variables = parser.serialize(fileContent), !variables.isEmpty else {
            XCTFail("Failed to parse variables body.")
            return
        }
        print(variables)
    }
}
