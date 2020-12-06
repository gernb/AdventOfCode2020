//
//  main.swift
//  Day 06
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

enum Part1 {
    static func uniqueAnswers(for group: String) -> Int {
        Set(group.replacingOccurrences(of: "\n", with: "").map(String.init)).count
    }

    static func run(_ source: InputData) {
        let input = source.data
        let sum = input.map(uniqueAnswers).reduce(0, +)
        print("Part 1 (\(source)):")
        print("Sum of unique answers is: \(sum)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func commonAnswers(for group: String) -> Int {
        let people = group.components(separatedBy: .newlines)
            .map { Set($0.map(String.init)) }
        let allAnswers = Set("abcdefghijklmnopqrstuvwxyz".map(String.init))
        let common = people.reduce(allAnswers) { $0.intersection($1) }
        return common.count
    }

    static func run(_ source: InputData) {
        let input = source.data
        let sum = input.map(commonAnswers).reduce(0, +)
        print("Part 2 (\(source)):")
        print("Sum of common answers is: \(sum)")
    }
}

InputData.allCases.forEach(Part2.run)
