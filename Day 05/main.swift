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
        if (source == .challenge) {
            print("Highest seat ID is: \(seatIds.max()!)")
        } else {
            seatIds.enumerated().forEach {
                print("\(input[$0].joined()) -> \($1)")
            }
        }
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func boardingPass(for seatId: Int) -> [String] {
        let row = seatId / 8
        let column = seatId - row * 8

        print("Seat ID is Row \(row), Column \(column)")

        var pass = [String]()
        var rows = 0 ... 127
        var columns = 0 ... 7

        while rows.lowerBound != rows.upperBound {
            let halfRange = (rows.upperBound - rows.lowerBound) / 2
            let lowerHalf = rows.lowerBound ... (rows.lowerBound + halfRange)
            let upperHalf = (rows.lowerBound + halfRange + 1) ... rows.upperBound
            if lowerHalf.contains(row) {
                pass.append("F")
                rows = lowerHalf
            } else {
                pass.append("B")
                rows = upperHalf
            }
        }

        while columns.lowerBound != columns.upperBound {
            let halfRange = (columns.upperBound - columns.lowerBound) / 2
            let lowerHalf = columns.lowerBound ... (columns.lowerBound + halfRange)
            let upperHalf = (columns.lowerBound + halfRange + 1) ... columns.upperBound
            if lowerHalf.contains(column) {
                pass.append("L")
                columns = lowerHalf
            } else {
                pass.append("R")
                columns = upperHalf
            }
        }

        return pass
    }

    static func run(_ source: InputData) {
        let input = source.data

        let seatIds = input.map(Part1.seatId).sorted()
        let allSeats = Set(seatIds.first! ... seatIds.last!)
        let emptySeats = allSeats.subtracting(seatIds)

        print("Part 2 (\(source)):")
        print("Your seat ID is: \(emptySeats)")

        let pass = boardingPass(for: emptySeats.first!)
        print("Your boarding pass is: \(pass.joined())")
        assert(!input.contains(pass))
    }
}

Part2.run(.challenge)
