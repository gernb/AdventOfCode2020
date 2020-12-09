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

    static func findInvalidNumber(_ source: InputData) -> Int {
        let (len, input) = source.data
        for (idx, number) in input.enumerated().dropFirst(len) {
            let previousNumbers = Set(input[idx - len ..< idx])
            if !isValid(number: number, for: previousNumbers) {
                return number
            }
        }
        fatalError()
    }

    static func run(_ source: InputData) {
        let number = findInvalidNumber(source)
        print("Part 1 (\(source)):")
        print("Found invalid entry: \(number)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let (_, input) = source.data
        let invalidNumber = Part1.findInvalidNumber(source)
        print("Part 2 (\(source)):")
        for startIdx in 0 ..< input.count - 1 {
            for endIdx in startIdx + 1 ..< input.count {
                let sum = input[startIdx ... endIdx].reduce(0, +)
                if sum == invalidNumber {
                    let slice = input[startIdx ... endIdx]
                    let result = slice.min()! + slice.max()!
                    print("Min + Max = \(result) for\n\(slice)")
                    return
                }
                if sum > invalidNumber {
                    break
                }
            }
        }
    }
}

InputData.allCases.forEach(Part2.run)
