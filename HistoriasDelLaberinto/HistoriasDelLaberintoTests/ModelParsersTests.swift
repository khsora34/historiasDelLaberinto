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
        let protagonist = parser.serialize(fileContent)
        
        XCTAssertNotNil(protagonist)
        print(protagonist!)
    }
    
    func testCharactersProtagonistModel() {
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
        guard let items = parser.serialize(fileContent) else {
            XCTFail("Failed parsing items file.")
            return
        }
        print(items)
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
        let rooms = parser.serialize(fileContent)
        XCTAssertNotNil(rooms)
        print(rooms!)
    }
    
}
