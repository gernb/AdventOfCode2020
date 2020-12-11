//
//  main.swift
//  Day 11
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

struct Coordinate: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    static let origin: Self = .init(x: 0, y: 0)

    var description: String { "(\(x), \(y))" }

    var up: Self { .init(x: x, y: y - 1) }
    var down: Self { .init(x: x, y: y + 1) }
    var left: Self { .init(x: x - 1, y: y) }
    var right: Self { .init(x: x + 1, y: y) }
    var upLeft: Self { .init(x: x - 1, y: y - 1) }
    var upRight: Self { .init(x: x + 1, y: y - 1) }
    var downLeft: Self { .init(x: x - 1, y: y + 1) }
    var downRight: Self { .init(x: x + 1, y: y + 1) }

    var adjacent: [Self] { [upLeft, up, upRight, left, right, downLeft, down, downRight] }
}

extension Array where Element: MutableCollection, Element.Index == Int {
    subscript(_ coordinate: Coordinate) -> Element.Element? {
        get { self[coordinate.x, coordinate.y] }
        set { self[coordinate.x, coordinate.y] = newValue! }
    }

    subscript(_ x: Int, _ y: Int) -> Element.Element? {
        get {
            guard y >= 0 && y < self.count && x >= 0 && x < self[y].count else { return nil }
            return self[y][x]
        }
        set { self[y][x] = newValue! }
    }
}

// MARK: - Part 1

print("Day 11:")

extension Array where Element: MutableCollection, Element.Index == Int, Element.Element == String {
    func countOfOccupiedSeats(at location: Coordinate) -> Int {
        location.adjacent.map { self[$0] == "#" ? 1 : 0 }.reduce(0, +)
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        var seatLayout = source.data

        while true {
            var nextSeatLayout = seatLayout
            for (y, row) in seatLayout.enumerated() {
                for (x, spot) in row.enumerated() {
                    let location = Coordinate(x: x, y: y)
                    switch spot {
                    case "L": // empty seat
                        if seatLayout.countOfOccupiedSeats(at: location) == 0 {
                            nextSeatLayout[location] = "#" // now occupied
                        }
                    case "#": // occupied seat
                        if seatLayout.countOfOccupiedSeats(at: location) >= 4 {
                            nextSeatLayout[location] = "L" // now empty
                        }
                    default:
                        break
                    }
                }
            }
            if nextSeatLayout == seatLayout {
                break
            }
            seatLayout = nextSeatLayout
        }

        print("Part 1 (\(source)):")
        let count = seatLayout.map { $0.reduce(0) { $0 + ($1 == "#" ? 1 : 0) } }.reduce(0, +)
        print("Occupied seats at quiescence: \(count)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

extension Array where Element: MutableCollection, Element.Index == Int, Element.Element == String {
    func isOccupied(from location: Coordinate, in direction: KeyPath<Coordinate, Coordinate>) -> Bool {
        let adjustedLocation = location[keyPath: direction]
        switch self[adjustedLocation] {
        case .none: return false
        case "L": return false
        case "#": return true
        case ".": return isOccupied(from: adjustedLocation, in: direction)
        default: fatalError()
        }
    }

    func countOfOccupiedSeatsPart2(at location: Coordinate) -> Int {
        [
            isOccupied(from: location, in: \.upLeft),
            isOccupied(from: location, in: \.up),
            isOccupied(from: location, in: \.upRight),
            isOccupied(from: location, in: \.left),
            isOccupied(from: location, in: \.right),
            isOccupied(from: location, in: \.downLeft),
            isOccupied(from: location, in: \.down),
            isOccupied(from: location, in: \.downRight),
        ].map { $0 ? 1 : 0 }.reduce(0, +)
    }

    func draw() {
        for y in 0 ..< self.count {
            for x in 0 ..< self[y].count {
                let pixel = self[Coordinate(x: x, y: y)]!
                print(pixel, terminator: "")
            }
            print("")
        }
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        var seatLayout = source.data

        while true {
            var nextSeatLayout = seatLayout
            for (y, row) in seatLayout.enumerated() {
                for (x, spot) in row.enumerated() {
                    let location = Coordinate(x: x, y: y)
                    switch spot {
                    case "L": // empty seat
                        if seatLayout.countOfOccupiedSeatsPart2(at: location) == 0 {
                            nextSeatLayout[location] = "#" // now occupied
                        }
                    case "#": // occupied seat
                        if seatLayout.countOfOccupiedSeatsPart2(at: location) >= 5 {
                            nextSeatLayout[location] = "L" // now empty
                        }
                    default:
                        break
                    }
                }
            }
            if nextSeatLayout == seatLayout {
                break
            }
            seatLayout = nextSeatLayout
        }

        print("Part 2 (\(source)):")
        let count = seatLayout.map { $0.reduce(0) { $0 + ($1 == "#" ? 1 : 0) } }.reduce(0, +)
        print("Occupied seats at quiescence: \(count)")
    }
}

InputData.allCases.forEach(Part2.run)
