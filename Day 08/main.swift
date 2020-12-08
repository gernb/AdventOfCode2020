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
    private(set) var ip = 0
    let program: [Operation]

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

    init(_ program: [Operation]) {
        self.program = program
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
    enum ProgramResult: Comparable {
        case halted(Int)
        case looped(Int)
    }

    static func runProgram(_ program: [HandheldComputer.Operation]) -> ProgramResult {
        let computer = HandheldComputer(program)
        var executedIPs = Set<Int>([0])
        while true {
            let nextIP = computer.step()
            if executedIPs.contains(nextIP) {
                return .looped(computer.accumulator)
            } else if nextIP >= program.count {
                return .halted(computer.accumulator)
            }
            executedIPs.insert(nextIP)
        }
    }

    static func run(_ source: InputData) {
        let input = source.data
        let computer = HandheldComputer(input)

        print("Part 2 (\(source)):")

        for (idx, op) in computer.program.enumerated() {
            switch op {
            case .acc: continue
            case .jmp(let arg):
                var program = computer.program
                program[idx] = .nop(arg)
                let result = runProgram(program)
                if case .halted(let value) = result {
                    print("Halted with value: \(value)")
                    print("Changed <jmp \(arg)> to <nop \(arg)> on line \(idx)")
                    return
                }
            case .nop(let arg):
                var program = computer.program
                program[idx] = .jmp(arg)
                let result = runProgram(program)
                if case .halted(let value) = result {
                    print("Halted with value: \(value)")
                    print("Changed <nop \(arg)> to <jmp \(arg)> on line \(idx)")
                    return
                }
            }
        }
    }
}

InputData.allCases.forEach(Part2.run)
