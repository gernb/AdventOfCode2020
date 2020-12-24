//
//  InputData.swift
//  Day 22
//
//  Copyright © 2020 peter bohac. All rights reserved.
//

enum InputData: String, CaseIterable {
    case example, challenge

    var data: [[String]] {
        switch self {

        case .example: return """
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
""".components(separatedBy: "\n\n").map { $0.components(separatedBy: .newlines) }

        case .challenge: return """
Player 1:
44
24
36
6
27
46
33
45
47
41
15
23
40
38
43
42
25
5
30
35
34
13
29
1
50

Player 2:
32
28
4
12
9
21
48
18
31
39
20
16
3
37
49
7
17
22
8
26
2
14
11
19
10
""".components(separatedBy: "\n\n").map { $0.components(separatedBy: .newlines) }

        }
    }
}
