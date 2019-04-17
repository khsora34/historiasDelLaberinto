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
        guard let characters = parser.serialize(fileContent) else {
            XCTFail("Failed to parse characters body.")
            return
        }
        print(characters)
    }
    
    func testItemsProtagonistModel() {
        guard let path = Bundle.main.path(forResource: "prota", ofType: "yml", inDirectory: "loadedGame") else {
            XCTFail("Couldn't find prota.yml in loadedGame directory.")
            return
        }
        
        guard let fileContent = try? String(contentsOfFile: path) else {
            XCTFail("Unable to read the content of the file in path \(path).")
            return
        }
        
        let parser = ProtagonistParser()
        let protagonist = parser.serialize(fileContent)
        XCTAssertNotNil(protagonist)
    }
    
    func testEventsProtagonistModel() {
        guard let path = Bundle.main.path(forResource: "prota", ofType: "yml", inDirectory: "loadedGame") else {
            XCTFail("Couldn't find prota.yml in loadedGame directory.")
            return
        }
        
        guard let fileContent = try? String(contentsOfFile: path) else {
            XCTFail("Unable to read the content of the file in path \(path).")
            return
        }
        
        let parser = ProtagonistParser()
        let protagonist = parser.serialize(fileContent)
        XCTAssertNotNil(protagonist)
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
        guard let rooms = parser.serialize(fileContent) else {
            XCTFail("Failed to parse characters body.")
            return
        }
        print(rooms)
    }
    
}
