//
//  combinatorics.swift
//  Combinatorics
//
//  Created by David M. Reed on 3/11/18.
//  Copyright © 2018 David Reed. All rights reserved.
//


// based on pseudo-code in Discrete Mathematics, 7th Edition, Richard Johnsonbaugh pp. 302-304

public func factorial(_ n: Int) -> Int {
    guard n > 1 else {
        return 1
    }
    var r = 1
    for i in 2...n {
        r *= i
    }
    return r
}

public func nChooseK(n: Int, k: Int) -> Int {
    return factorial(n) / (factorial(n - k) * factorial(k))
}

public func nPermutationsK(n: Int, k: Int) -> Int {
    return factorial(n) / factorial(n - k)
}

public struct CombinationsGenerator<T>: Sequence {

    public init(items: [T], k: Int) {
        self.items = items
        chooseK = k
    }

    public func makeIterator() -> AnyIterator<[T]> {
        guard items.count > 0 else {
            return AnyIterator {
                return nil
            }
        }
        var i = 0
        let n = items.count
        let k = chooseK
        var indices = Array(0..<k)
        let numCombinations = nChooseK(n: n, k: k)
        let collection = items
        return AnyIterator {
            if i == 0 {
                i += 1
                return indices.map { collection[$0] }
            } else {
                guard i < numCombinations else {
                    return nil
                }
                i += 1
                var m = k - 1
                var maxVal = n - 1
                while m >= 0 && indices[m] == maxVal {
                    // find rightmost element not at its maxium value
                    m -= 1
                    maxVal -= 1
                }
                // rightmost element is incremented
                if m >= 0 {
                    indices[m] += 1
                    if m + 1 < k {
                        for j in m+1..<k {
                            indices[j] = indices[j-1] + 1
                        }
                    }
                }
                return indices.map { collection[$0] }
            }
        }
    }

    private var items: [T]
    private var chooseK: Int
}

public struct PermutationsGenerator<T> : Sequence {

    public init(items: [T]) {
        self.items = items
    }

    public func makeIterator() -> AnyIterator<[T]> {
        guard items.count > 0 else {
            return AnyIterator {
                return nil
            }
        }
        var i = 0
        let n = items.count
        var indices = Array(0..<n)
        let numPermutations = factorial(n)
        let collection = items
        return AnyIterator {
            if i == 0 {
                i += 1
                return indices.map { collection[$0] }
            } else {
                guard i < numPermutations else {
                    return nil
                }
                i += 1
                var m = n - 2
                while indices[m] > indices[m+1] {
                    m -= 1
                }
                var k = n - 1
                while k >= 0 && indices[m] > indices[k] {
                    k -= 1
                }
                indices.swapAt(m, k)
                var p = m + 1
                var q = n - 1
                while p < q {
                    indices.swapAt(p, q)
                    p += 1
                    q -= 1
                }
                return indices.map { collection[$0] }
            }
        }
    }
    private var items: [T]
}

public struct KPermutationsGenerator<T>: Sequence {
    public init(items: [T], k: Int) {
        self.items = items
        chooseK = k
    }

    public func makeIterator() -> AnyIterator<[T]> {
        let items = self.items

        guard items.count > 0 else {
            return AnyIterator {
                return nil
            }
        }

        let k = chooseK
        let cg = CombinationsGenerator(items: items, k: k).makeIterator()

        // if we have a first combination (which will unless items is empty array)
        if let c = cg.next() {
            // make permutation generator for that combination
            var pg = PermutationsGenerator(items: c).makeIterator()
            return AnyIterator {
                // if we have a next permutation of that combination, return it
                if let p = pg.next() {
                    return p
                } else {
                    // we ran out of permutations for that combination, so get next combination
                    if let c = cg.next() {
                        // make permutation generator for that combination
                        pg = PermutationsGenerator(items: c).makeIterator()
                        return pg.next()
                    }
                }
                return nil
            }
        }

        // empty sequence so no combinations
        return AnyIterator {
            return nil
        }
    }

    private var items: [T]
    private var chooseK: Int
}


extension Sequence {

    func combinations(k: Int) -> AnyIterator<[Iterator.Element]> {
        let items = Array(self)
        return CombinationsGenerator(items: items, k: k).makeIterator()
    }

    func permutations() -> AnyIterator<[Iterator.Element]> {
        let items = Array(self)
        return PermutationsGenerator(items: items).makeIterator()
    }

    func kPermutations(k: Int) -> AnyIterator<[Iterator.Element]> {
        let items = Array(self)
        return KPermutationsGenerator(items: items, k: k).makeIterator()
    }
}

