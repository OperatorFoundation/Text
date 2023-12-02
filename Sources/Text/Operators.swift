//
//  Operators.swift
//
//
//  Created by Dr. Brandon Wiley on 12/2/23.
//

import Foundation

import Starfish

prefix operator ⟝
prefix operator ⟞

infix operator ∩
infix operator ∾

public func ℤ(_ scalar: UnicodeScalar) -> Bool
{
    return Text.numeric(scalar)
}

public prefix func ⟝(_ text: Text) throws -> Text
{
    return try text.first()
}

public prefix func ⟞(_ text: Text) throws -> Text
{
    return try text.last()
}

public func ∩(_ x: Text, _ keep: (UnicodeScalar) -> Bool) -> Text
{
    return x.filter(keep: keep)
}

public func ∾(_ x: Text, _ y: Text) -> Text
{
    return x.append(y)
}
