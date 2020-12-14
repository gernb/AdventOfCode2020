//
//  main.swift
//  Day 14
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 14:")

enum Part1 {
    typealias Mask = [(index: Int, value: Int)]

    enum Instruction {
        case mask(Mask)
        case store(address: Int, value: Int)

        init(rawValue: String) {
            if rawValue.hasPrefix("mask") {
                let parts = rawValue.components(separatedBy: " = ")
                let mask = parts[1].reversed().enumerated().compactMap { idx, char in
                    char == "X" ? nil : (idx, Int(String(char))!)
                }
                self = .mask(mask)
            } else if rawValue.hasPrefix("mem") {
                let parts = rawValue.components(separatedBy: " = ")
                let address = Int(parts[0].dropFirst(4).dropLast())!
                let value = Int(parts[1])!
                self = .store(address: address, value: value)
            } else {
                fatalError()
            }
        }
    }

    static func applyMask(_ mask: Mask, to value: Int) -> Int {
        var value = value
        mask.forEach { idx, bit in
            if bit == 1 {
                value |= 1 << idx
            } else {
                value &= ~(1 << idx)
            }
        }
        return value
    }

    static func run(_ source: InputData) {
        let input = source.data.map(Instruction.init)
        var memory = [Int: Int]()
        var mask = Mask()
        input.forEach { instruction in
            switch instruction {
            case .mask(let newMask): mask = newMask
            case .store(let address, let value): memory[address] = applyMask(mask, to: value)
            }
        }

        print("Part 1 (\(source)): \(memory.values.reduce(0, +))")
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
