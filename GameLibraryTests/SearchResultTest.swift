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

class SearchResultTest: XCTestCase {
    
    var viewModel: SearchResultViewModel!
    var networkingService: MockService!
    var dispatch: DispatchQueueType!
    var realmService: RealmService!
    
    override func setUpWithError() throws {
        networkingService = MockService()
        dispatch = DispatchQueueMock()
        realmService = RealmService(test: true)
        viewModel = SearchResultViewModel(service: networkingService, realmService: realmService, dispatchQueue: dispatch)
    }
    
    override func tearDownWithError() throws {
        networkingService = nil
        dispatch = nil
        
        try! realmService.realm.write{
            realmService.realm.deleteAll()
        }
        realmService = nil
        viewModel = nil
    }
    
    func testExample() throws {
        
        viewModel.fetchData(str: "hey")
        XCTAssertEqual(viewModel.searchedGameApi?.results.count, 10)
    }
    
    func testRealm(){
        viewModel.fetchData(str: "str")
        
        let objects = viewModel.realmService.get(GameRealm.self)
        
        XCTAssertEqual(objects?.count, 10)
    }
    
    func testCleanRealm(){
        viewModel.fetchData(str: "str")
        viewModel.cleanRealm()
        
        let objects = viewModel.realmService.get(GameRealm.self)
        
        XCTAssertEqual(objects, nil)
    }
    
    func testFetchRealm(){
        viewModel.fetchData(str: "str")
        viewModel.searchedGameApi = nil
        
        viewModel.fetchFromRealm()
        
        let objects = viewModel.realmService.get(GameRealm.self)
        
        XCTAssertEqual(objects?.count, 10)
    }
    
}


final class DispatchQueueMock: DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
