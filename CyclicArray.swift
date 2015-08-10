//
//  CyclicArray.swift
//
//  Created by Shay Levy on 3/14/15.
//  Copyright (c) 2015 Shay Levy. All rights reserved.
//

import Foundation

struct CyclicArray<T> : SequenceType {
    var _array = [T]()
    var _nextPosition: Int = 0
    var _size:Int = 0
    var _count: Int = 0
    init(size:Int) {
        _array.reserveCapacity(size)
        _size = size
    }
    
    mutating func push(t:T) {
        if _count < _size {
            _array.append(t)
        } else {
            _array[_nextPosition] = t
        }
        _nextPosition++
        _count++
        if _nextPosition == _size {
            _nextPosition = 0
        }
        if (_count>_size) {
            _count = _size
        }
    }
    
    // Can't change the array while iterating it, not safe!!
    func generate() -> AnyGenerator<T> {
        var itemFetched: Int = 0
        var nextIndex = _nextPosition
        if nextIndex == _size || _count < _size {
            nextIndex = 0
        }
        var end = (_count == 0)
        return anyGenerator {
            if end == true {
                return nil
            }
            let returnEntity = self._array[nextIndex]
            nextIndex++
            if nextIndex == self._size {
                nextIndex = 0
            }
            itemFetched++
            if (itemFetched == self._count) {
                end = true
            }
            
            return returnEntity
        }
    }
}
