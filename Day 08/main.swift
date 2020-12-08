//
//  main.swift
//  Day 08
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 8:")

final class HandheldComputer {
    private(set) var accumulator = 0
    private var ip = 0
    private let program: [Operation]

    enum Operation {
        case acc(Int) // accumulate
        case jmp(Int) // jump
        case nop(Int) // no-op
    }

    init(_ source: [String]) {
        self.program = source.map { line in
            let parts = line.components(separatedBy: " ")
            let (instruction, argument) = (parts[0], Int(parts[1])!)
            switch instruction {
            case "acc": return .acc(argument)
            case "jmp": return .jmp(argument)
            case "nop": return .nop(argument)
            default: fatalError()
            }
        }
    }

    func step() -> Int {
        switch program[ip] {

        case .acc(let value):
            accumulator += value
            ip += 1

        case .jmp(let offset):
            ip += offset

        case .nop:
            ip += 1
        }

        return ip
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data
        let computer = HandheldComputer(input)
        var executedIPs = Set<Int>([0])
        while true {
            let nextIP = computer.step()
            if executedIPs.contains(nextIP) {
                break
            }
            executedIPs.insert(nextIP)
        }

        print("Part 1 (\(source)):")
        print("Accumulator value at start of 2nd loop: \(computer.accumulator)")
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
