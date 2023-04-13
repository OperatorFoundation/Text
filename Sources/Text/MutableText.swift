//
//  MutableText.swift
//  
//
//  Created by Dr. Brandon Wiley on 4/11/23.
//

import Foundation

import Datable
import SwiftHexTools

public final class MutableText: TextProtocol
{
    public var text: Text

    public init()
    {
        self.text = Text()
    }

    public init(fromUTF8String: String)
    {
        self.text = Text(fromUTF8String: fromUTF8String)
    }

    public func toUTF8String() -> String
    {
        return self.text.string
    }
}

// Equatable
extension MutableText: Equatable
{
    public static func == (lhs: MutableText, rhs: MutableText) -> Bool
    {
        lhs.text == rhs.text
    }
}

// Hashable
extension MutableText: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.text)
    }
}

// ExpressableByStringLiteral
extension MutableText: ExpressibleByStringLiteral
{
    public typealias StringLiteralType = String

    public convenience init(stringLiteral value: String)
    {
        self.init(fromUTF8String: value)
    }
}

// Comparable
extension MutableText: Comparable
{
    public static func < (lhs: MutableText, rhs: MutableText) -> Bool
    {
        return lhs.text < rhs.text
    }
}

// Datable
extension MutableText: MaybeDatable
{
    public convenience init?(data: Data)
    {
        self.init(fromUTF8String: data.string)
    }

    public var data: Data
    {
        return self.text.data
    }
}

// Text conversion
extension MutableText
{
    public convenience init(fromText: Text)
    {
        self.init(fromUTF8String: fromText.string)
    }

    public func toText() -> Text
    {
        return self.text
    }
}

// UTF8 Data conversion
extension MutableText
{
    public convenience init?(fromUTF8Data: Data)
    {
        self.init(fromUTF8String: fromUTF8Data.string)
    }

    public func toUTF8Data() -> Data
    {
        return self.text.data
    }
}

// Hex conversion
extension MutableText
{
    public convenience init?(fromHex: Text)
    {
        let hexString = fromHex.string
        guard let data = Data(hex: hexString) else
        {
            return nil
        }

        let string = data.string

        self.init(fromUTF8String: string)
    }

    public func toHex() -> Text
    {
        return self.text.toHex()
    }

    public func convertFromHex() throws
    {
        self.text = try Text(fromHex: self.text)
    }

    public func convertToHex()
    {
        self.text = self.toHex()
    }
}

// Base64 conversion
extension MutableText
{
    public convenience init(fromBase64: Text) throws
    {
        let hexString = fromBase64.string
        guard let data = Data(base64: hexString) else
        {
            throw MutableTextError.conversionFailed
        }

        let string = data.string

        self.init(fromUTF8String: string)
    }

    public func toBase64() -> Text
    {
        return self.text.toBase64()
    }

    public func convertFromBase64() throws
    {
        self.text = try Text(fromBase64: self.toText())
    }

    public func convertToBase64()
    {
        self.text = self.text.toBase64()
    }
}

// Substring
extension MutableText
{
    public func substring(_ startInclusive: Int, _ endExclusive: Int) throws -> Text
    {
        return try self.text.substring(startInclusive, endExclusive)
    }

    public func becomeSubstring(_ startInclusive: Int, _ endExclusive: Int) throws
    {
        self.text = try self.text.substring(startInclusive, endExclusive)
    }
}

// IndexOf
extension MutableText
{
    public func indexOf(_ text: Text) throws -> Int
    {
        return try self.text.indexOf(text)
    }
}

// Split
extension MutableText
{
    public func split(_ separator: Text) -> [Text]
    {
        return self.text.split(separator)
    }

    public func splitOn(_ value: Text) throws -> (Text, Text)
    {
        return try self.text.splitOn(value)
    }

    public func splitAt(_ index: Int) throws -> (Text, Text)
    {
        return try self.text.splitAt(index)
    }

    public func becomeSplit(_ separator: Text, _ index: Int) throws
    {
        let parts = self.split(separator)

        guard index > 0, index < parts.count else
        {
            throw MutableTextError.badIndex(index)
        }

        self.text = parts[index]
    }

    public func becomeSplitOnHead(_ value: Text) throws
    {
        let (head, _) = try self.splitOn(value)
        self.text = head
    }

    public func becomeSplitOnTail(_ value: Text) throws
    {
        let (_, tail) = try self.splitOn(value)
        self.text = tail
    }

    public func becomeSplitAtHead(_ index: Int) throws
    {
        let (head, _) = try self.splitAt(index)
        self.text = head
    }

    public func becomeSplitAtTail(_ index: Int) throws
    {
        let (_, tail) = try self.splitAt(index)
        self.text = tail
    }
}

// Trim
extension MutableText
{
    public func trim() -> Text
    {
        return self.text.trim()
    }

    public func becomeTrimmed()
    {
        self.text = self.text.trim()
    }
}

// Join
extension MutableText
{
    public func join(_ parts: [Text]) -> Text
    {
        return self.text.join(parts)
    }

    public func becomeJoined(_ parts: [Text])
    {
        self.text = self.join(parts)
    }
}

// Prepend, append
extension MutableText
{
    public func prepend(_ prefix: Text) -> Text
    {
        return self.text.prepend(prefix)
    }

    public func append(_ suffix: Text) -> Text
    {
        return self.text.append(suffix)
    }

    public func becomePrepended(prefix: Text)
    {
        self.text = self.text.prepend(prefix)
    }

    public func becomeAppended(suffix: Text)
    {
        self.text = self.text.append(suffix)
    }
}

public enum MutableTextError: Error
{
    case badIndex(Int)
    case notFound
    case conversionFailed
}
