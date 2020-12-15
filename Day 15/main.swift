//
//  main.swift
//  Day 15
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 15:")

enum Part1 {
    static func run(_ source: InputData) {
        var input = source.data
        for turn in input.count ..< 2020 {
            let last = input.last!
            if let previous = input.dropLast().lastIndex(of: last) {
                input.append(turn - previous - 1)
            } else {
                input.append(0)
            }
        }
        print("Part 1 (\(source)): 2020th number is \(input.last!)")
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
