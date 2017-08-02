//
//  Quick+Extension.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 3..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import Quick
import Nimble
import RxTest


struct AnyEquatable<Target>
: Equatable {
    typealias Comparer = (Target, Target) -> Bool
    
    let _target: Target
    let _comparer: Comparer
    
    init(target: Target, comparer: @escaping Comparer) {
        _target = target
        _comparer = comparer
    }
}

func == <T>(lhs: AnyEquatable<T>, rhs: AnyEquatable<T>) -> Bool {
    return lhs._comparer(lhs._target, rhs._target)
}

extension AnyEquatable
    : CustomDebugStringConvertible
, CustomStringConvertible  {
    var description: String {
        return "\(_target)"
    }
    
    var debugDescription: String {
        return "\(_target)"
    }
}

public func equal<T: Equatable>(_ expectedValue: [Recorded<Event<T>>]?) -> Predicate<[Recorded<Event<T>>]> {
    return Predicate.define("equal <\(stringify(expectedValue))>") { actualExpression, msg in
        let actualValue = try actualExpression.evaluate()
        guard let actualVal = actualValue, let expectedVal = expectedValue else {
            return PredicateResult(
                status: .fail,
                message: msg.appendedBeNilHint()
            )
        }
        let leftEquatable = actualVal.map { AnyEquatable(target: $0, comparer: ==) }
        let rightEquatable = expectedVal.map { AnyEquatable(target: $0, comparer: ==) }
        if leftEquatable == rightEquatable {
            return PredicateResult(bool: true, message: msg)
        }else {
            return PredicateResult(status: .fail, message: msg)
        }
    }
}
