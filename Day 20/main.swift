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

    static func cornerTiles(in tiles: [Tile]) -> [Tile] {
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
        return tilesAndEdgeCounts.filter { $0.matchingEdges == 2 }.map(\.0)
    }

    static func run(_ source: InputData) {
        let tiles = source.data.map(Tile.init)
        let corners = cornerTiles(in: tiles)
        print("Part 1 (\(source)): \(corners.reduce(1) { $0 * $1.id })")
        print(corners.map(\.id))
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

extension Array where Element == [Int] {
    mutating func flip() {
        self = self.reversed()
    }

    mutating func rotate() {
        assert(count == first?.count) // must be square
        var newArray = [Element]()
        for i in 0 ..< count {
            newArray.append(self.map { $0[i] }.reversed())
        }
        self = newArray
    }

    func draw() {
        for y in 0 ..< count {
            for x in 0 ..< self[y].count {
                print((self[y][x] == 1 ? "#" : "."), terminator: "")
            }
            print("")
        }
    }
}

final class TileNode {
    let id: Int
    var image: [[Int]]
    let allEdges: Set<Int>
    var connectedTiles: [Edge: TileNode]

    var currentEdges: [Int] {
        [ value(for: .top), value(for: .right), value(for: .bottom), value(for: .left) ]
    }

    var trimmedImage: [[Int]] {
        image.dropFirst().dropLast().map { $0.dropFirst().dropLast() }
    }

    enum Edge {
        case top, bottom, left, right
        var opposite: Edge {
            switch self {
            case .top: return .bottom
            case .bottom: return .top
            case .left: return .right
            case .right: return .left
            }
        }
    }

    init(_ string: String) {
        let lines = string.components(separatedBy: .newlines)
        id = Int(lines.first!.components(separatedBy: " ").last!.dropLast())!
        image = lines.dropFirst().map { $0.map { $0 == "#" ? 1: 0 } }
        allEdges = .init([
            Int(image.first!.map(String.init).joined(), radix: 2)!,
            Int(image.first!.map(String.init).reversed().joined(), radix: 2)!,
            Int(image.last!.map(String.init).joined(), radix: 2)!,
            Int(image.last!.map(String.init).reversed().joined(), radix: 2)!,
            Int(image.map { String($0.first!) }.joined(), radix: 2)!,
            Int(image.map { String($0.first!) }.reversed().joined(), radix: 2)!,
            Int(image.map { String($0.last!) }.joined(), radix: 2)!,
            Int(image.map { String($0.last!) }.reversed().joined(), radix: 2)!,
        ])
        connectedTiles = [:]
    }

    init(_ tile: TileNode) {
        self.id = tile.id
        self.image = tile.image
        self.allEdges = tile.allEdges
        self.connectedTiles = tile.connectedTiles
    }

    func value(for edge: Edge) -> Int {
        switch edge {
        case .top: return Int(image.first!.map(String.init).joined(), radix: 2)!
        case .bottom: return Int(image.last!.map(String.init).joined(), radix: 2)!
        case .left: return Int(image.map { String($0.first!) }.joined(), radix: 2)!
        case .right: return Int(image.map { String($0.last!) }.joined(), radix: 2)!
        }
    }

    func flipped() -> TileNode {
        let newTile = TileNode(self)
        newTile.image.flip()
        return newTile
    }

    func rotated() -> TileNode {
        let newTile = TileNode(self)
        newTile.image.rotate()
        return newTile
    }

    func allPositions() -> [TileNode] {
        var result = [TileNode(self)]
        result.append(result.last!.rotated())
        result.append(result.last!.rotated())
        result.append(result.last!.rotated())
        result.append(result.last!.flipped())
        result.append(result.last!.rotated())
        result.append(result.last!.rotated())
        result.append(result.last!.rotated())
        return result
    }
}

extension TileNode: Equatable {
    static func == (lhs: TileNode, rhs: TileNode) -> Bool {
        lhs.id == rhs.id
    }
}

enum Part2 {
    static var tiles = [Int: TileNode]()

    static func firstCornerId(_ source: InputData) -> Int {
        Part1.cornerTiles(in: source.data.map(Tile.init)).map(\.id).first!
    }

    static func tilesMatching(tile: TileNode, edge: Int) -> [TileNode] {
        var result = [TileNode]()
        for other in tiles.values {
            if other == tile { continue }
            if other.allEdges.contains(edge) {
                result.append(other)
            }
        }
        return result
    }

    static func fitFirstTile(_ node: TileNode) {
        for tile in node.allPositions() {
            let rightMatch = tilesMatching(tile: tile, edge: tile.value(for: .right)).first
            let bottomMatch = tilesMatching(tile: tile, edge: tile.value(for: .bottom)).first
            if let _ = rightMatch, let _ = bottomMatch {
                node.image = tile.image
                return
            }
        }
    }

    static func fitRow(_ root: TileNode, isFirst: Bool = false) {
        var current = root
        while true {
            let rightEdge = current.value(for: .right)
            let matches = tilesMatching(tile: current, edge: rightEdge)
            if matches.count == 0 {
                return
            }
            assert(matches.count == 1)
            let tile = matches.first!.allPositions().first(where: { $0.value(for: .left) == rightEdge })!
            current.connectedTiles[.right] = tile
            tile.connectedTiles[.left] = current

            let topMatches = tilesMatching(tile: tile, edge: tile.value(for: .top))
            if isFirst {
                assert(topMatches.count == 0)
            } else {
                assert(topMatches.count == 1)
                tile.connectedTiles[.top] = topMatches.first!
                topMatches.first!.connectedTiles[.bottom] = tile
            }
            current = tile
        }
    }

    static func fitRest(_ root: TileNode) {
        var current = root
        while true {
            let bottomEdge = current.value(for: .bottom)
            let matches = tilesMatching(tile: current, edge: bottomEdge)
            if matches.count == 0 {
                return
            }
            assert(matches.count == 1)
            let tile = matches.first!.allPositions().first(where: { $0.value(for: .top) == bottomEdge })!
            current.connectedTiles[.bottom] = tile
            tile.connectedTiles[.top] = current
            fitRow(tile)
            current = tile
        }
    }

    static func stitchImage(startingFrom root: TileNode) -> [[Int]] {
        var image: [[Int]] = []
        var current: TileNode? = root
        while let row = current {
            var lines = row.trimmedImage
            var next = row.connectedTiles[.right]
            while let tile = next {
                tile.trimmedImage.enumerated().forEach { idx, line in
                    lines[idx].append(contentsOf: line)
                }
                next = tile.connectedTiles[.right]
            }
            image.append(contentsOf: lines)
            current = row.connectedTiles[.bottom]
        }
        return image
    }

    static let seaMonster = [
        "                  # ",
        "#    ##    ##    ###",
        " #  #  #  #  #  #   "
    ].map { line in
        line.map { $0 == "#" ? 1 : 0 }
    }

    static func searchImage(_ image: inout [[Int]]) -> Int {
        var found = 0
        let monsterInts = seaMonster.map { Int($0.map(String.init).joined(), radix: 2)! }
        let monsterLen = seaMonster[0].count
        for y in 0 ..< image.count - (seaMonster.count - 1) {
            for x in 0 ..< image[y].count - (monsterLen - 1) {
                let imageInts = [
                    image[y][x ..< x + monsterLen],
                    image[y + 1][x ..< x + monsterLen],
                    image[y + 2][x ..< x + monsterLen],
                ].map { line in
                    Int(line.map(String.init).joined(), radix: 2)!
                }
                if zip(imageInts, monsterInts).allSatisfy({ imageInt, monsterInt in
                    imageInt & monsterInt == monsterInt
                }) {
                    found += 1
                }
            }
        }
        return found
    }

    static func run(_ source: InputData) {
        tiles = source.data.map(TileNode.init)
            .reduce(into: [Int: TileNode]()) { $0[$1.id] = $1 }
        let firstCorner = tiles[firstCornerId(source)]!
        let root = tiles[firstCorner.id]!
        fitFirstTile(root)
        fitRow(root, isFirst: true)
        fitRest(root)
        var image = stitchImage(startingFrom: root)
        var allPositions = Array(repeating: image, count: 8)
        allPositions[1].rotate()
        allPositions[2] = allPositions[1]; allPositions[2].rotate()
        allPositions[3] = allPositions[2]; allPositions[3].rotate()
        allPositions[4] = allPositions[3]; allPositions[4].flip()
        allPositions[5] = allPositions[4]; allPositions[5].rotate()
        allPositions[6] = allPositions[5]; allPositions[6].rotate()
        allPositions[7] = allPositions[6]; allPositions[7].rotate()
        var monsterCount = 0
        for idx in allPositions.indices {
            let count = searchImage(&allPositions[idx])
            if count > 0 {
                image = allPositions[idx]
                monsterCount = count
                break
            }
        }
        let monsterPixelCount = seaMonster.map { $0.reduce(0, +) }.reduce(0, +)
        let imagePixelCount = image.map { $0.reduce(0, +) }.reduce(0, +)
        let roughness = imagePixelCount - monsterPixelCount * monsterCount
        print("Part 2 (\(source)) water roughness: \(roughness)")
    }
}

InputData.allCases.forEach(Part2.run)
