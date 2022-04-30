//
//  EncodableExtension.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 26.04.2022.
//

import Foundation



extension Encodable {
    /// Encode into JSON and return `Data`
    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
}
