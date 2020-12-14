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

Part1.run(.example)
Part1.run(.challenge)

// MARK: - Part 2

print("")

enum Part2 {
    enum Bit {
        case setToOne, floating
    }

    typealias Mask = [(index: Int, value: Bit)]

    enum Instruction {
        case mask(Mask)
        case store(address: Int, value: Int)

        init(rawValue: String) {
            if rawValue.hasPrefix("mask") {
                let parts = rawValue.components(separatedBy: " = ")
                let mask = parts[1].reversed().enumerated().compactMap { idx, char -> (Int, Bit)? in
                    switch char {
                    case "1": return (idx, .setToOne)
                    case "X": return (idx, .floating)
                    default: return nil
                    }
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

    static func addressesFor(_ address: Int, with mask: Mask) -> [Int] {
        // Apply all the "set bit" parts of the mask
        let address = mask
            .filter { $0.value == .setToOne }
            .reduce(into: address) { $0 |= 1 << $1.index }
        // For every floating bit, double the result making one "1" and the other "0" for that bit
        return mask.filter { $0.value == .floating }
            .reduce([address]) { result, bit -> [Int] in
                result
                    .flatMap { [
                        $0 | 1 << bit.index,
                        $0 & ~(1 << bit.index)
                    ] }
            }
    }

    static func run(_ source: InputData) {
        let input = source.data.map(Instruction.init)
        var memory = [Int: Int]()
        var mask = Mask()
        input.forEach { instruction in
            switch instruction {
            case .mask(let newMask):
                mask = newMask
            case .store(let address, let value):
                addressesFor(address, with: mask).forEach { memory[$0] = value }
            }
        }

        print("Part 2 (\(source)): \(memory.values.reduce(0, +))")
    }
}

Part2.run(.example2)
Part2.run(.challenge)
