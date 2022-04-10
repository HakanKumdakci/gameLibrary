//
//  GameDetailTest.swift
//  GameLibraryTests
//
//  Created by Hakan Kumdakçı on 10.04.2022.
//

import XCTest
@testable import GameLibrary

class GameDetailTest: XCTestCase {
    
    var viewModel: GameDetailViewModel!
    var service: MockService!

    override func setUpWithError() throws {
        service = MockService()
        viewModel = GameDetailViewModel(service: service)
    }

    override func tearDownWithError() throws {
        service = nil
        viewModel.service = nil
        viewModel = nil
    }

    func testExample() throws {
        viewModel.game = Game(id: 3489, name: "", genres: [Genre(name: "")])
        viewModel.fetchData()
        
        
        XCTAssertEqual(viewModel.gameDetail.id, 3489)
        
    }
    
}
