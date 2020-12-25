//
//  main.swift
//  Day 24
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// reference: https://www.redblobgames.com/grids/hexagons/
struct Coordinate: Hashable {
    let x: Int
    let y: Int
    let z: Int

    static let origin = Coordinate(x: 0, y: 0, z: 0)

    var northWest: Coordinate { return Coordinate(x: x, y: y + 1, z: z - 1) }
    var northEast: Coordinate { return Coordinate(x: x + 1, y: y, z: z - 1) }
    var east: Coordinate { return Coordinate(x: x + 1, y: y - 1, z: z) }
    var southEast: Coordinate { return Coordinate(x: x, y: y - 1, z: z + 1) }
    var southWest: Coordinate { return Coordinate(x: x - 1, y: y, z: z + 1) }
    var west: Coordinate { return Coordinate(x: x - 1, y: y + 1, z: z) }

    func distance(to other: Coordinate) -> Int {
        let xDiff = abs(x - other.x)
        let yDiff = abs(y - other.y)
        let zDiff = abs(z - other.z)
        return (xDiff + yDiff + zDiff) / 2
    }
}

enum Direction: String {
    case nw, w, ne, se, e, sw
}

extension Coordinate {
    mutating func move(_ d: Direction) {
        switch d {
        case .nw: self = self.northWest
        case .w: self = self.west
        case .ne: self = self.northEast
        case .sw: self = self.southWest
        case .e: self = self.east
        case .se: self = self.southEast
        }
    }
}

enum Colour {
    case white, black
}

// MARK: - Part 1

print("Day 24:")

enum Part1 {
    static func parse(_ line: String) -> [Direction] {
        var result = [Direction]()
        let letters = line.map(String.init)
        var idx = 0
        while idx < letters.count {
            switch letters[idx] {
            case "w":
                result.append(.w)
                idx += 1
            case "e":
                result.append(.e)
                idx += 1
            case "n":
                letters[idx + 1] == "w" ? result.append(.nw) : result.append(.ne)
                idx += 2
            case "s":
                letters[idx + 1] == "w" ? result.append(.sw) : result.append(.se)
                idx += 2
            default:
                fatalError()
            }
        }
        return result
    }

    static func run(_ source: InputData) {
        let input = source.data
        var tiles: [Coordinate: Colour] = [:]
        input.forEach { line in
            var position = Coordinate.origin
            parse(line).forEach { dir in position.move(dir) }
            if tiles[position, default: .white] == .white {
                tiles[position] = .black
            } else {
                tiles.removeValue(forKey: position)
            }
        }

        print("Part 1 (\(source)): \(tiles.count)")
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
