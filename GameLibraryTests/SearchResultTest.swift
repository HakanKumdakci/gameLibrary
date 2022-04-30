//
//  GamesViewModelTest.swift
//  GameLibraryTests
//
//  Created by Hakan Kumdakçı on 10.04.2022.
//

import XCTest
@testable import GameLibrary
import Realm
import RealmSwift
import Moya
class SearchResultTest: XCTestCase {
    
    var viewModel: SearchResultViewModel!
    var dispatch: DispatchQueueType!
    var realmService: RealmService!
    
    override func setUpWithError() throws {
        dispatch = DispatchQueueMock()
        realmService = RealmService(test: true)
        viewModel = SearchResultViewModel(realmService: realmService, dispatchQueue: dispatch)
        viewModel.gameProvider = MoyaProvider<MoyaService>(stubClosure: MoyaProvider.immediatelyStub)
    }
    
    override func tearDownWithError() throws {
        dispatch = nil
        
        try! realmService.realm?.write{
            realmService.realm?.deleteAll()
        }
        realmService = nil
        viewModel = nil
    }
    
    func testExample() throws {
        
        viewModel.fetchData(str: "hey")
        XCTAssertEqual(viewModel.searchedGameApi?.results.count, 10)
    }
    
    func testRealm() {
        viewModel.fetchData(str: "str")
        
        let objects = viewModel.realmService?.get(GameRealm.self)
        
        XCTAssertEqual(objects?.count, 10)
    }
    
    func testCleanRealm() {
        viewModel.fetchData(str: "str")
        viewModel.cleanRealm()
        
        let objects = viewModel.realmService?.get(GameRealm.self)
        
        XCTAssertEqual(objects, nil)
    }
    
    func testFetchRealm() {
        viewModel.fetchData(str: "str")
        viewModel.searchedGameApi = nil
        
        viewModel.fetchFromRealm()
        
        let objects = viewModel.realmService?.get(GameRealm.self)
        
        XCTAssertEqual(objects?.count, 10)
    }
    
}


final class DispatchQueueMock: DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
