//
//  main.swift
//  Day 19
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation


struct Rule {
    let id: Int
    let matches: String

    init(string: String) {
        let parts = string.components(separatedBy: ": ")
        self.id = Int(parts[0])!
        if parts[1].hasPrefix("\"") {
            self.matches = String(parts[1].dropFirst().first!)
        } else {
            self.matches = "( " + parts[1] + " )"
        }
    }
}

// MARK: - Part 1

print("Day 11:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data
        let rules = input[0].map(Rule.init).reduce(into: [Int: Rule]()) {
            $0[$1.id] = $1
        }

        var matches = rules[0]!.matches
        while matches.contains(where: { Int(String($0)) != nil }) {
            matches = matches
                .components(separatedBy: " ")
                .map { token in
                    if let id = Int(token) {
                        return rules[id]!.matches
                    } else {
                        return token
                    }
                }
                .joined(separator: " ")
        }

        let regex = "^" + matches.replacingOccurrences(of: " ", with: "") + "$"
        let count = input[1].filter({ $0.range(of: regex, options: .regularExpression) != nil }).count

        print("Part 1 (\(source)): \(count)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}

InputData.allCases.forEach(Part2.run)
