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

extension NSRegularExpression {
    func matchLen(_ string: String) -> Int {
        let range = NSRange(location: 0, length: string.utf16.count)
        return rangeOfFirstMatch(in: string, range: range).length
    }
}

enum Part2 {
    static func regex(for rule: Rule, using rules: [Int: Rule]) -> String {
        var matches = rule.matches
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

        return matches.replacingOccurrences(of: " ", with: "")
    }

    static func run(_ source: InputData) {
        let input = source.data
        let rules = input[0].map(Rule.init).reduce(into: [Int: Rule]()) {
            $0[$1.id] = $1
        }

        let r31 = try! NSRegularExpression(pattern: regex(for: Rule(string: "999: ( 31 )+"), using: rules) + "$")

        let r = "^" + regex(for: Rule(string: "0: 42 ( 42 )+ ( 31 )+"), using: rules) + "$"
        let filtered = input[1].filter({ $0.range(of: r, options: .regularExpression) != nil })

        let count = filtered.filter { r31.matchLen($0) < ($0.count / 2) }.count
        print("Part 2 (\(source)): \(count)")
    }
}

Part2.run(.example2)
Part2.run(.challenge)
