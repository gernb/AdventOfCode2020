//
//  main.swift
//  Day 22
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 22:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data
        var player1 = input[0].dropFirst().compactMap(Int.init)
        var player2 = input[1].dropFirst().compactMap(Int.init)

        while !player1.isEmpty && !player2.isEmpty {
            let p1 = player1.removeFirst()
            let p2 = player2.removeFirst()
            if p1 > p2 {
                player1.append(contentsOf: [p1, p2])
            } else {
                player2.append(contentsOf: [p2, p1])
            }
        }

        let winner = player1.isEmpty ? player2 : player1
        let score = winner.reversed().enumerated().reduce(0) { (sum, pair) in
            sum + (pair.offset + 1) * pair.element
        }
        print("Part 1 (\(source)): \(score)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    final class RecursiveCombat {
        struct Round: Hashable {
            let player1: [Int]
            let player2: [Int]
        }

        enum Winner {
            case player1, player2
        }

        var player1: [Int]
        var player2: [Int]
        var rounds: Set<Round>

        var score: Int {
            let winner = player1.isEmpty ? player2 : player1
            return winner.reversed().enumerated().reduce(0) { (sum, pair) in
                sum + (pair.offset + 1) * pair.element
            }
        }

        init(player1: [Int], player2: [Int]) {
            self.player1 = player1
            self.player2 = player2
            self.rounds = .init()
        }

        func play() -> Winner {
            while !player1.isEmpty && !player2.isEmpty {
                let currentRound = Round(player1: player1, player2: player2)
                if rounds.contains(currentRound) {
                    print("Infinite recursion rule; Player 1 wins!")
                    return .player1
                }
                rounds.insert(currentRound)

                let p1 = player1.removeFirst()
                let p2 = player2.removeFirst()
                if player1.count >= p1 && player2.count >= p2 {
                    print("Starting a sub-game...")
                    let subGame = RecursiveCombat(player1: Array(player1[..<p1]), player2: Array(player2[..<p2]))
                    switch subGame.play() {
                    case .player1:
                        player1.append(contentsOf: [p1, p2])
                    case .player2:
                        player2.append(contentsOf: [p2, p1])
                    }
                } else {
                    if p1 > p2 {
                        player1.append(contentsOf: [p1, p2])
                    } else {
                        player2.append(contentsOf: [p2, p1])
                    }
                }
            }

            if player2.isEmpty {
                print("Player 1 won!")
                return .player1
            } else {
                print("Player 2 won!")
                return .player2
            }
        }
    }

    static func run(_ source: InputData) {
        let input = source.data
        let player1 = input[0].dropFirst().compactMap(Int.init)
        let player2 = input[1].dropFirst().compactMap(Int.init)
        let game = RecursiveCombat(player1: player1, player2: player2)
        _ = game.play()

        print("Part 2 (\(source)): \(game.score)")
    }
}

let example2 = Part2.RecursiveCombat(player1: [43, 19], player2: [2, 29, 14])
_ = example2.play()

InputData.allCases.forEach(Part2.run)
