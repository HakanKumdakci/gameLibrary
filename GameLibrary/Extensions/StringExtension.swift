//
//  StringExtension.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 26.04.2022.
//

import Foundation


extension String {
    
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }
    
    func levenshteinDistanceScore(to string: String, ignoreCase: Bool = true, trimWhiteSpacesAndNewLines: Bool = true) -> Double {

        var firstString = self
        var secondString = string

        if ignoreCase {
            firstString = firstString.lowercased()
            secondString = secondString.lowercased()
        }
        if trimWhiteSpacesAndNewLines {
            firstString = firstString.trimmingCharacters(in: .whitespacesAndNewlines)
            secondString = secondString.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        let empty = [Int](repeating:0, count: secondString.count)
        var last = [Int](0...secondString.count)

        for (i, tLett) in firstString.enumerated() {
            var cur = [i + 1] + empty
            for (j, sLett) in secondString.enumerated() {
                cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j])+1
            }
            last = cur
        }

        // maximum string length between the two
        let lowestScore = max(firstString.count, secondString.count)

        if let validDistance = last.last {
            return  1 - (Double(validDistance) / Double(lowestScore))
        }

        return 0.0
    }
}
