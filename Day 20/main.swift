//
//  main.swift
//  Day 20
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

struct Tile {
    let id: Int
    let image: [[Int]]

    let top: (Int, Int)
    let bottom: (Int, Int)
    let left: (Int, Int)
    let right: (Int, Int)

    var edges: [(Int, Int)] { [top, right, bottom, left] }

    init(_ string: String) {
        let lines = string.components(separatedBy: .newlines)
        id = Int(lines.first!.components(separatedBy: " ").last!.dropLast())!
        image = lines.dropFirst().map { $0.map { $0 == "#" ? 1: 0 } }

        top = (
            Int(image.first!.map(String.init).joined(), radix: 2)!,
            Int(image.first!.map(String.init).reversed().joined(), radix: 2)!
            )
        bottom = (
            Int(image.last!.map(String.init).joined(), radix: 2)!,
            Int(image.last!.map(String.init).reversed().joined(), radix: 2)!
            )
        left = (
            Int(image.map { String($0.first!) }.joined(), radix: 2)!,
            Int(image.map { String($0.first!) }.reversed().joined(), radix: 2)!
            )
        right = (
            Int(image.map { String($0.last!) }.joined(), radix: 2)!,
            Int(image.map { String($0.last!) }.reversed().joined(), radix: 2)!
            )
    }
}

// MARK: - Part 1

print("Day 20:")

enum Part1 {
    static func allEdges(except tile: Tile, tiles: [Tile]) -> Set<Int> {
        var edges = Set<Int>()
        tiles.forEach { t in
            if t.id == tile.id { return }
            for edge in t.edges {
                edges.insert(edge.0)
                edges.insert(edge.1)
            }
        }
        return edges
    }

    static func run(_ source: InputData) {
        let tiles = source.data.map(Tile.init)
        let tilesAndEdgeCounts: [(tile: Tile, matchingEdges: Int)] = tiles.map { tile in
            let otherEdges = allEdges(except: tile, tiles: tiles)
            let matches = tile.edges.reduce(0) { result, edge in
                if otherEdges.contains(edge.0) || otherEdges.contains(edge.1) {
                    return result + 1
                } else {
                    return result
                }
            }
            return (tile, matches)
        }
        let cornerTiles = tilesAndEdgeCounts.filter { $0.matchingEdges == 2 }

        print("Part 1 (\(source)): \(cornerTiles.reduce(1) { $0 * $1.tile.id })")
        print(cornerTiles.map { $0.tile.id })
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
