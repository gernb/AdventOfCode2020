//
//  main.swift
//  Day 22
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 22:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data
        var player1 = input[0].dropFirst().compactMap(Int.init)
        var player2 = input[1].dropFirst().compactMap(Int.init)

        while !player1.isEmpty && !player2.isEmpty {
            let p1 = player1.removeFirst()
            let p2 = player2.removeFirst()
            if p1 > p2 {
                player1.append(contentsOf: [p1, p2])
            } else {
                player2.append(contentsOf: [p2, p1])
            }
        }

        let winner = player1.isEmpty ? player2 : player1
        let score = winner.reversed().enumerated().reduce(0) { (sum, pair) in
            sum + (pair.offset + 1) * pair.element
        }
        print("Part 1 (\(source)): \(score)")
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
