//
//  main.swift
//  Day 09
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 9:")

enum Part1 {
    static func isValid(number: Int, for preamble: Set<Int>) -> Bool {
        for value in preamble {
            if preamble.subtracting([value]).contains(number - value) {
                return true
            }
        }
        return false
    }

    static func run(_ source: InputData) {
        let (len, input) = source.data
        print("Part 1 (\(source)):")
        for (idx, number) in input.enumerated().dropFirst(len) {
            let previousNumbers = Set(input[idx - len ..< idx])
            if !isValid(number: number, for: previousNumbers) {
                print("Found invalid entry: \(number) at position: \(idx)")
                break
            }
        }
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
