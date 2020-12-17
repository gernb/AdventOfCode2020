//
//  InputData.swift
//  Day 17
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

enum InputData: String, CaseIterable {
    case example, challenge

    var data: [[String]] {
        switch self {

        case .example: return """
.#.
..#
###
""".components(separatedBy: .newlines).map { $0.map(String.init) }

        case .challenge: return """
##.#...#
#..##...
....#..#
....####
#.#....#
###.#.#.
.#.#.#..
.#.....#
""".components(separatedBy: .newlines).map { $0.map(String.init) }

        }
    }
}
