//
//  MutableText.swift
//  
//
//  Created by Dr. Brandon Wiley on 4/11/23.
//

import Foundation

import Datable
import SwiftHexTools

public final class MutableText: Codable
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
    public func split(separator: Text) -> [Text]
    {
        return self.text.split(separator: separator)
    }

    public func split(on value: Text) throws -> (Text, Text)
    {
        return try self.text.split(on: value)
    }

    public func split(at index: Int) throws -> (Text, Text)
    {
        return try self.text.split(at: index)
    }

    public func becomeSplit(separator: Text, index: Int) throws
    {
        let parts = self.split(separator: separator)

        guard index > 0, index < parts.count else
        {
            throw MutableTextError.badIndex(index)
        }

        self.text = parts[index]
    }

    public func becomeSplitHead(on value: Text) throws
    {
        let (head, _) = try self.split(on: value)
        self.text = head
    }

    public func becomeSplitTail(on value: Text) throws
    {
        let (_, tail) = try self.split(on: value)
        self.text = tail
    }

    public func becomeSplitHead(at index: Int) throws
    {
        let (head, _) = try self.split(at: index)
        self.text = head
    }

    public func becomeSplitTail(at index: Int) throws
    {
        let (_, tail) = try self.split(at: index)
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

public enum MutableTextError: Error
{
    case badIndex(Int)
    case notFound
    case conversionFailed
}
