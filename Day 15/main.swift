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
        var spoken = [Int: Int]()
        input.dropLast().enumerated().forEach { idx, number in spoken[number] = idx + 1 }
        var next = input.last!
        for turn in input.count ... 30000000 - 1 {
            if let previouslySpoken = spoken[next] {
                spoken[next] = turn
                next = turn - previouslySpoken
            } else {
                spoken[next] = turn
                next = 0
            }
        }
        print("Part 2 (\(source)): 30000000th number is \(next)")
    }
}

InputData.allCases.forEach(Part2.run)
