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

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}

InputData.allCases.forEach(Part2.run)
