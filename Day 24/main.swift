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

    static func layoutTiles(_ source: InputData) -> [Coordinate: Colour] {
        var tiles: [Coordinate: Colour] = [:]
        source.data.forEach { line in
            var position = Coordinate.origin
            parse(line).forEach { dir in position.move(dir) }
            if tiles[position, default: .white] == .white {
                tiles[position] = .black
            } else {
                tiles.removeValue(forKey: position)
            }
        }
        return tiles
    }

    static func run(_ source: InputData) {
        let tiles = layoutTiles(source)

        print("Part 1 (\(source)): \(tiles.count)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

extension Coordinate {
    var adjacent: [Coordinate] {
        [ northWest, northEast, east, southEast, southWest, west ]
    }
}

extension Collection where Element == Int {
    func range() -> ClosedRange<Element> {
        precondition(count > 0)
        let sorted = self.sorted()
        return (sorted.first! - 1) ... (sorted.last! + 1)
    }
}

extension Dictionary where Key == Coordinate {
    var xRange: ClosedRange<Int> { keys.map { $0.x }.range() }
    var yRange: ClosedRange<Int> { keys.map { $0.y }.range() }
    var zRange: ClosedRange<Int> { keys.map { $0.z }.range() }
}

enum Part2 {
    static func run(_ source: InputData) {
        var tiles = Part1.layoutTiles(source)

        for _ in 1...100 {
            var newTiles = [Coordinate: Colour]()
            for x in tiles.xRange {
                for y in tiles.yRange {
                    for z in tiles.zRange {
                        let c = Coordinate(x: x, y: y, z: z)
                        let tile = tiles[c, default: .white]
                        let adjacentBlack = c.adjacent
                            .map { tiles[$0, default: .white] == .black ? 1 : 0 }
                            .reduce(0, +)
                        switch (tile, adjacentBlack) {
                        case (.black, 1), (.black, 2):
                            newTiles[c] = .black
                        case (.white, 2):
                            newTiles[c] = .black
                        default:
                            break
                        }

                    }
                }
            }
            tiles = newTiles
        }

        print("Part 2 (\(source)): \(tiles.count)")
    }
}

InputData.allCases.forEach(Part2.run)
