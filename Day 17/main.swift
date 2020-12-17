//
//  main.swift
//  Day 17
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

struct Vector3: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int
    var z: Int

    static let zero: Self = .init(x: 0, y: 0, z: 0)

    var description: String { "(\(x), \(y), \(z))" }

    var neighbours: [Self] {[
        .init(x: x + 1, y: y, z: z),
        .init(x: x - 1, y: y, z: z),
        .init(x: x, y: y + 1, z: z),
        .init(x: x, y: y - 1, z: z),
        .init(x: x + 1, y: y + 1, z: z),
        .init(x: x - 1, y: y - 1, z: z),
        .init(x: x - 1, y: y + 1, z: z),
        .init(x: x + 1, y: y - 1, z: z),

        .init(x: x, y: y, z: z - 1),
        .init(x: x + 1, y: y, z: z - 1),
        .init(x: x - 1, y: y, z: z - 1),
        .init(x: x, y: y + 1, z: z - 1),
        .init(x: x, y: y - 1, z: z - 1),
        .init(x: x + 1, y: y + 1, z: z - 1),
        .init(x: x - 1, y: y - 1, z: z - 1),
        .init(x: x - 1, y: y + 1, z: z - 1),
        .init(x: x + 1, y: y - 1, z: z - 1),

        .init(x: x, y: y, z: z + 1),
        .init(x: x + 1, y: y, z: z + 1),
        .init(x: x - 1, y: y, z: z + 1),
        .init(x: x, y: y + 1, z: z + 1),
        .init(x: x, y: y - 1, z: z + 1),
        .init(x: x + 1, y: y + 1, z: z + 1),
        .init(x: x - 1, y: y - 1, z: z + 1),
        .init(x: x - 1, y: y + 1, z: z + 1),
        .init(x: x + 1, y: y - 1, z: z + 1),
    ]}
}

enum State: String {
    case active = "#"
    case inactive = "."
}

extension Collection where Element == Int {
    func range() -> ClosedRange<Element> {
        precondition(count > 0)
        let sorted = self.sorted()
        return sorted.first! - 1 ... sorted.last! + 1
    }
}

extension Dictionary where Key == Vector3, Value == State {
    var xRange: ClosedRange<Int> { keys.map { $0.x }.range() }
    var yRange: ClosedRange<Int> { keys.map { $0.y }.range() }
    var zRange: ClosedRange<Int> { keys.map { $0.z }.range() }

    func activeNeighbours(for cube: Vector3) -> Int {
        cube.neighbours.reduce(0) { $0 + (self[$1, default: .inactive] == .active ? 1 : 0) }
    }
}

// MARK: - Part 1

print("Day 17:")

enum Part1 {
    static func run(_ source: InputData) {
        var grid = source.data.enumerated().reduce(into: [Vector3: State]()) { result, pair in
            let (y, line) = pair
            result = line.enumerated().reduce(into: result) { result, pair in
                let (x, state) = pair
                result[Vector3(x: x, y: y, z: 0)] = State(rawValue: state)!
            }
        }

        for _ in 1 ... 6 {
            var newGrid = [Vector3: State]()
            for x in grid.xRange {
                for y in grid.yRange {
                    for z in grid.zRange {
                        let cube = Vector3(x: x, y: y, z: z)
                        switch (grid[cube, default: .inactive], grid.activeNeighbours(for: cube)) {
                        case (.active, 2), (_, 3):
                            newGrid[cube] = .active
                        default:
                            break
                        }
                    }
                }
            }
            grid = newGrid
        }

        let activeCount = grid.values.filter { $0 == .active }.count

        print("Part 1 (\(source)): \(activeCount)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

struct Vector4: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int
    var z: Int
    var w: Int

    static let zero: Self = .init(x: 0, y: 0, z: 0, w: 0)

    var description: String { "(\(x), \(y), \(z), \(w))" }

    var neighbours: [Self] {
        var result = Set<Self>()
        for x in -1 ... 1 {
            for y in -1 ... 1 {
                for z in -1 ... 1 {
                    for w in -1 ... 1 {
                        result.insert(.init(x: self.x + x, y: self.y + y, z: self.z + z, w: self.w + w))
                    }
                }
            }
        }
        return Array(result.subtracting([self]))
    }
}

extension Dictionary where Key == Vector4, Value == State {
    var xRange: ClosedRange<Int> { keys.map { $0.x }.range() }
    var yRange: ClosedRange<Int> { keys.map { $0.y }.range() }
    var zRange: ClosedRange<Int> { keys.map { $0.z }.range() }
    var wRange: ClosedRange<Int> { keys.map { $0.w }.range() }

    func activeNeighbours(for cube: Vector4) -> Int {
        cube.neighbours.reduce(0) { $0 + (self[$1, default: .inactive] == .active ? 1 : 0) }
    }
}

print("")

enum Part2 {
    static func run(_ source: InputData) {
        var grid = source.data.enumerated().reduce(into: [Vector4: State]()) { result, pair in
            let (y, line) = pair
            result = line.enumerated().reduce(into: result) { result, pair in
                let (x, state) = pair
                result[Vector4(x: x, y: y, z: 0, w: 0)] = State(rawValue: state)!
            }
        }

        for _ in 1 ... 6 {
            var newGrid = [Vector4: State]()
            for x in grid.xRange {
                for y in grid.yRange {
                    for z in grid.zRange {
                        for w in grid.wRange {
                            let cube = Vector4(x: x, y: y, z: z, w: w)
                            switch (grid[cube, default: .inactive], grid.activeNeighbours(for: cube)) {
                            case (.active, 2), (_, 3):
                                newGrid[cube] = .active
                            default:
                                break
                            }
                        }
                    }
                }
            }
            grid = newGrid
        }

        let activeCount = grid.values.filter { $0 == .active }.count

        print("Part 2 (\(source)): \(activeCount)")
    }
}

InputData.allCases.forEach(Part2.run)
