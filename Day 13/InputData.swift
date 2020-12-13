//
//  InputData.swift
//  Day 13
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

enum InputData: String, CaseIterable {
    case example, example2, example3, example4, example5, example6, challenge

    var data: [String] {
        switch self {

        case .example: return """
939
7,13,x,x,59,x,31,19
1068781
""".components(separatedBy: .newlines)

        case .example2: return ["", "17,x,13,19", "3417"]
        case .example3: return ["", "67,7,59,61", "754018"]
        case .example4: return ["", "67,x,7,59,61", "779210"]
        case .example5: return ["", "67,7,x,59,61", "1261476"]
        case .example6: return ["", "1789,37,47,1889", "1202161486"]

        case .challenge: return """
1009310
19,x,x,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,599,x,29,x,x,x,x,x,x,x,x,x,x,x,x,x,x,17,x,x,x,x,x,23,x,x,x,x,x,x,x,761,x,x,x,x,x,x,x,x,x,41,x,x,13
1012171816131114
""".components(separatedBy: .newlines)

        }
    }
}
