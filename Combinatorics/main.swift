//
//  main.swift
//  Combinatorics
//
//  Created by David M. Reed on 3/11/18.
//  Copyright © 2018 David Reed. All rights reserved.
//


let items: [Int] = [3, 4, 5, 6]

for (i, x) in items.combinations(k: 3).enumerated() {
    print(i+1, x)
}
print(nChooseK(n: 4, k: 3))
print()

for (i, x) in items.permutations().enumerated() {
    print(i+1, x)
}
print(factorial(items.count))

print()
for (i, x) in [3, 4, 5, 6, 7].kPermutations(k: 3).enumerated() {
    print(i+1, x)
}
print(nPermutationsK(n: 5, k: 3))
print()

for (i, x) in [].kPermutations(k: 3).enumerated() {
    print(i+1, x)
}
