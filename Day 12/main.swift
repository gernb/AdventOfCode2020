//
//  main.swift
//  Day 12
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

enum Heading {
    case west, north, east, south

    var left: Self {
        switch self {
        case .west: return .south
        case .north: return .west
        case .east: return .north
        case .south: return .east
        }
    }

    var right: Self {
        switch self {
        case .west: return .north
        case .north: return .east
        case .east: return .south
        case .south: return .west
        }
    }
}

struct Coordinate: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    static let origin: Self = .init(x: 0, y: 0)

    var description: String { "(\(x), \(y))" }

    mutating func move(_ units: Int, direction: Heading) {
        switch direction {
        case .north: self = .init(x: x, y: y + units)
        case .south: self = .init(x: x, y: y - units)
        case .west: self = .init(x: x - units, y: y)
        case .east: self = .init(x: x + units, y: y)
        }
    }

    func distance(to other: Self) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
}

enum Instruction {
    case north(Int)
    case south(Int)
    case east(Int)
    case west(Int)
    case left(Int)
    case right(Int)
    case forward(Int)

    init(rawValue: String) {
        guard let value = Int(rawValue.dropFirst()) else { fatalError() }
        switch rawValue.first {
        case "N": self = .north(value)
        case "S": self = .south(value)
        case "E": self = .east(value)
        case "W": self = .west(value)
        case "L": self = .left(value)
        case "R": self = .right(value)
        case "F": self = .forward(value)
        default: fatalError()
        }
    }
}

// MARK: - Part 1

print("Day 12:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.map(Instruction.init)
        var position = Coordinate.origin
        var heading = Heading.east
        input.forEach { instruction in
            switch instruction {
            case .north(let units): position.move(units, direction: .north)
            case .south(let units): position.move(units, direction: .south)
            case .east(let units): position.move(units, direction: .east)
            case .west(let units): position.move(units, direction: .west)
            case .forward(let units): position.move(units, direction: heading)
            case .left(var units):
                while units > 0 {
                    heading = heading.left
                    units -= 90
                }
                assert(units == 0)
            case .right(var units):
                while units > 0 {
                    heading = heading.right
                    units -= 90
                }
                assert(units == 0)
            }
        }

        print("Part 1 (\(source)):")
        print("Final position is \(position.distance(to: .origin)) units away at \(position)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Direction {
    case left, right
}

extension Coordinate {
    mutating func moveTowards(_ waypoint: Coordinate, units: Int) {
        self = .init(x: self.x + waypoint.x * units, y: self.y + waypoint.y * units)
    }

    mutating func rotate(_ direction: Direction) {
        switch direction {
        case .left:
            self = .init(x: -self.y, y: self.x)

        case .right:
            self = .init(x: self.y, y: -self.x)
        }
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data.map(Instruction.init)
        var waypoint = Coordinate(x: 10, y: 1)
        var position = Coordinate.origin
        input.forEach { instruction in
            switch instruction {
            case .north(let units): waypoint.move(units, direction: .north)
            case .south(let units): waypoint.move(units, direction: .south)
            case .east(let units): waypoint.move(units, direction: .east)
            case .west(let units): waypoint.move(units, direction: .west)
            case .forward(let units): position.moveTowards(waypoint, units: units)
            case .left(var units):
                while units > 0 {
                    waypoint.rotate(.left)
                    units -= 90
                }
                assert(units == 0)
            case .right(var units):
                while units > 0 {
                    waypoint.rotate(.right)
                    units -= 90
                }
                assert(units == 0)
            }
        }

        print("Part 2 (\(source)):")
        print("Final position is \(position.distance(to: .origin)) units away at \(position)")
    }
}

InputData.allCases.forEach(Part2.run)
