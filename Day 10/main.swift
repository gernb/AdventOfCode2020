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
    static var countFromAdaptor = [Int: Int]()
    static func computeCount(start: Int, slice: ArraySlice<Int>) -> Int {
        guard slice.count > 0 else { return 1 }
        if let count = countFromAdaptor[start] {
            return count
        }
        var slice = slice
        var count = 0
        if let next = slice.first, next == start + 1 {
            slice = slice.dropFirst()
            let countForNext = computeCount(start: next, slice: slice)
            countFromAdaptor[next] = countForNext
            count += countForNext
        }
        if let next = slice.first, next == start + 2 {
            slice = slice.dropFirst()
            let countForNext = computeCount(start: next, slice: slice)
            countFromAdaptor[next] = countForNext
            count += countForNext
        }
        if let next = slice.first, next == start + 3 {
            slice = slice.dropFirst()
            let countForNext = computeCount(start: next, slice: slice)
            countFromAdaptor[next] = countForNext
            count += countForNext
        }
        return count
    }

    static func run(_ source: InputData) {
        let input = source.data.sorted()
        let list = input + [input.max()! + 3]
        countFromAdaptor = [:]
        let count = computeCount(start: 0, slice: ArraySlice(list))
        print("Part 2 (\(source)):")
        print("Total is \(count)")
    }
}

InputData.allCases.forEach(Part2.run)
