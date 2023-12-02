//
//  Operators.swift
//
//
//  Created by Dr. Brandon Wiley on 12/2/23.
//

import Foundation

infix operator ∩

public func ℤ(_ scalar: UnicodeScalar) -> Bool
{
    return Text.numeric(scalar)
}

public func ∩(_ x: Text, _ keep: (UnicodeScalar) -> Bool) -> Text
{
    return x.filter(keep: keep)
}
