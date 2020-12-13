//
//  main.swift
//  Day 13
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 13:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data
        let timestamp = Int(input[0])!
        let busIDs = input[1].components(separatedBy: ",").compactMap(Int.init)

        print("Part 1 (\(source)):")
        for time in timestamp... {
            for id in busIDs {
                if time % id == 0 {
                    let delay = time - timestamp
                    print("Bus ID \(id) leaves in \(delay) minutes for a product of \(id * delay)")
                    return
                }
            }
        }
    }
}

Part1.run(.example)
Part1.run(.challenge)

// MARK: - Part 2

print("")

func gcd(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

func lcm(_ m: Int, _ n: Int) -> Int {
    return (m * n) / gcd(m, n)
}

enum Part2 {
    // Doesn't work on the challenge input
    static func bruteForce(_ source: InputData) {
        let input = source.data
        let busIDs = input[1].components(separatedBy: ",").map(Int.init)
        let result = input.count == 3 ? Int(input[2])! : -1

        let start: Int
        if source == .challenge {
            start = (100000000000000 / busIDs[0]!) * busIDs[0]!
        } else {
            start = 0
        }

        print("Part 2 (\(source)):")
        for time in stride(from: start, to: Int.max, by: busIDs[0]!) {
            let mods = busIDs.indices.compactMap { idx -> Int? in
                guard let id = busIDs[idx] else { return nil }
                return (time + idx) % id
            }
            if mods.allSatisfy({ $0 == 0 }) {
                print("Timestamp: \(time) == \(result)? \(time == result)")
                return
            }
        }
    }

    // Increase the step size by the LCM of the bus IDs (step size for the bus) every time they match/align
    static func run(_ source: InputData) {
        let input = source.data
        let busses = input[1]
            .components(separatedBy: ",")
            .map(Int.init)
            .enumerated()
            .compactMap { idx, id -> (idx: Int, id: Int)? in
                guard let id = id else { return nil }
                return (idx, id)
            }
        let result = input.count == 3 ? Int(input[2])! : -1

        print("Part 2 (\(source)):")
        var time = 0
        var step = busses[0].id
        while true {
            let matches = busses.compactMap {
                (time + $0.idx) % $0.id == 0 ? $0.id : nil
            }
            if matches.count == busses.count {
                print("Timestamp: \(time) == \(result)? \(time == result)")
                return
            }
            if matches.count > 1 {
                step = matches.reduce(1, lcm)
            }
            time += step
        }
    }

    // Alternate solution:
    // Paste this string into WolframAlpha to get the answer...
    static func wolframAlpha(_ source: InputData) {
        let input = source.data
        let busIDs = input[1].components(separatedBy: ",").map(Int.init)
        let string = busIDs.enumerated().compactMap { idx, id -> String? in
            guard let id = id else { return nil }
            return "(t + \(idx)) mod \(id) = 0"
        }.joined(separator: ", ")
        print(string)
    }
}

InputData.allCases.forEach(Part2.run)
//InputData.allCases.forEach(Part2.wolframAlpha)
