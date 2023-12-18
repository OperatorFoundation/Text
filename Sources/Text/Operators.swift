//
//  Operators.swift
//
//
//  Created by Dr. Brandon Wiley on 12/2/23.
//

import Foundation

import Datable
import Starfish

prefix operator ⟝
prefix operator ⟞
prefix operator ⊩

infix operator ∩
infix operator ∾
infix operator ⇢

postfix operator ≡
postfix operator ⊜
postfix operator ↩

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

public prefix func ⊩<E>(_ xs: [E]) throws -> (E, [E])
{
    guard let first = xs.first else
    {
        throw OperatorsError.notEnoughElements
    }

    let rest = xs.dropFirst()

    return (first, [E](rest))
}

//public prefix func ⟝<E>(_ xs: [E]) throws -> E
//{
//    guard let result = xs.first else
//    {
//        throw TextError.textTooShort
//    }
//
//    return result
//}
//
//public prefix func ⟞<E>(_ xs: [E]) throws -> E
//{
//    guard let result = xs.first else
//    {
//        throw TextError.textTooShort
//    }
//
//    return result
//}

public func ∩(_ x: Text, _ keep: (UnicodeScalar) -> Bool) -> Text
{
    return x.filter(keep: keep)
}

public func ∾(_ x: Text, _ y: Text) -> Text
{
    return x.append(y)
}

public postfix func ≡(_ x: Text) -> [Text]
{
    return x.lines()
}

public postfix func ⊜(_ x: Text) throws -> Int
{
    guard let int = Int(x.string) else
    {
        throw OperatorsError.badConversion
    }

    return int
}

public func ⇢<Y>(_ xs: Text, _ f: (Text) throws -> Y) -> [Y]
{
    return xs.compactMap
    {
        x in

        do
        {
            return try f(x)
        }
        catch
        {
            return nil
        }
    }
}

public func ⇢<X,Y>(_ xs: [X], _ f: (X) throws -> Y) -> [Y]
{
    return xs.compactMap
    {
        x in

        do
        {
            return try f(x)
        }
        catch
        {
            return nil
        }
    }
}

public postfix func ↩(_ x: Text) -> Text
{
    return x.reverse()
}

public enum OperatorsError: Error
{
    case badConversion
    case notEnoughElements
}
