//
//  main.swift
//  Day 10
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 10:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.sorted()
        var previous = 0
        let differences = (input + [input.max()! + 3]).map { adaptor -> Int in
            defer { previous = adaptor }
            return adaptor - previous
        }
        print("Part 1 (\(source)):")
        print("Joltage differences: \(differences)")
        let oneJoltDiffs = differences.filter { $0 == 1 }.count
        let threeJoltDiffs = differences.filter { $0 == 3 }.count
        print("Result = \(oneJoltDiffs * threeJoltDiffs)\n")
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
