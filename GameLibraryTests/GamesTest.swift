//
//  GameLibraryTests.swift
//  GameLibraryTests
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import XCTest
@testable import GameLibrary
import Realm
import RealmSwift
import Moya

class GameLibraryTests: XCTestCase {
    
    var viewModel: GamesViewModel!
    
    override func setUpWithError() throws {
        viewModel = GamesViewModel()
        viewModel.gameProvider = MoyaProvider<MoyaService>(stubClosure: MoyaProvider.immediatelyStub)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testExample() throws {
        
        viewModel.fetchData { _ in
        }
        XCTAssertEqual(viewModel.gameApi?.results.count, 10)
        
        }

}

