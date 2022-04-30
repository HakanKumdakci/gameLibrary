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

class GameLibraryTests: XCTestCase {
    
    var viewModel: GamesViewModel!
    var service: MockService!
    
    override func setUpWithError() throws {
        
        service = MockService()
        
        viewModel = GamesViewModel(service: service)
    }

    override func tearDownWithError() throws {
        service = nil
        viewModel.service = nil
        viewModel = nil
    }

    func testExample() throws {
        
        viewModel.fetchData { _ in
        }
        XCTAssertEqual(viewModel.gameApi?.results.count, 10)
        
        }

}



class MockService: NetworkingServiceProtocol{
    func getData<T>(_ t: T.Type, url: String, completion: @escaping (T) -> Void) where T : Decodable, T : Encodable {
        var str = "data"
        //if gameDetail calls
        if url.split(separator: "/").contains("games") == true{
            str = "dataInstance"
        }
        if let url = Bundle.main.url(forResource: str, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(T.self, from: data)
                    completion(jsonData)
                } catch {
                    print("error:\(error)")
                }
        }else{
            print()
        }
    }
}

