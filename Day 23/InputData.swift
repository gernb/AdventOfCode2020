//
//  InputData.swift
//  Day 23
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

enum InputData: String, CaseIterable {
    case example, challenge

    var data: [Int] {
        switch self {

        case .example: return "389125467".map { Int(String($0))! }

        case .challenge: return "792845136".map { Int(String($0))! }

        }
    }
}
