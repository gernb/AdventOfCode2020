//
//  main.swift
//  Day 05
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

enum Part1 {
    static func seatId(for pass: [String]) -> Int {
        var row = 0...127
        var column = 0...7

        pass.forEach { character in
            switch character {
            case "F":
                let range = row.upperBound - row.lowerBound
                row = (row.lowerBound) ... (row.lowerBound + range / 2)
            case "B":
                let range = row.upperBound - row.lowerBound
                row = (row.lowerBound + range / 2 + 1) ... (row.upperBound)
            case "L":
                let range = column.upperBound - column.lowerBound
                column = (column.lowerBound) ... (column.lowerBound + range / 2)
            case "R":
                let range = column.upperBound - column.lowerBound
                column = (column.lowerBound + range / 2 + 1) ... (column.upperBound)
            default:
                fatalError()
            }
        }
        return row.lowerBound * 8 + column.lowerBound
    }

    static func run(_ source: InputData) {
        let input = source.data
        let seatIds = input.map(seatId)

        print("Part 1 (\(source)):")
        if (source != .challenge) {
            seatIds.enumerated().forEach {
                print("\(input[$0]) -> \($1)")
            }
        }
        print("Highest seat ID is: \(seatIds.max()!)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data
        let seatIds = input.map(Part1.seatId).sorted()

        print("Part 2 (\(source)):")
        for (idx, seatId) in seatIds.enumerated().dropFirst() {
            if seatId - seatIds[idx - 1] != 1 {
                print("Your seat ID is: \(seatId - 1)")
                break
            }
        }
    }
}

Part2.run(.challenge)
