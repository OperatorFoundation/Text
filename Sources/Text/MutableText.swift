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

// Become
extension MutableText
{
    public func become(text: Text)
    {
        self.text = text
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

    public func substringRegex(_ regex: Regex<AnyRegexOutput>) throws -> Text
    {
        return try self.text.substringRegex(regex)
    }

    public func becomeSubstring(_ startInclusive: Int, _ endExclusive: Int) throws
    {
        self.text = try self.text.substring(startInclusive, endExclusive)
    }

    public func becomeSubstringRegex(_ regex: Regex<AnyRegexOutput>) throws
    {
        self.text = try self.text.substringRegex(regex)
    }
}

// IndexOf
extension MutableText
{
    public func indexOf(_ text: Text) throws -> Int
    {
        return try self.text.indexOf(text)
    }

    public func lastIndexOf(_ text: Text) throws -> Int
    {
        return try self.text.lastIndexOf(text)
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

    public func splitOnLast(_ value: Text) throws -> (Text, Text)
    {
        return try self.text.splitOnLast(value)
    }

    public func splitAt(_ index: Int, _ length: Int = 0) throws -> (Text, Text)
    {
        return try self.text.splitAt(index, length)
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

    public func becomeSplitOnLastHead(_ value: Text) throws
    {
        let (head, _) = try self.splitOnLast(value)
        self.text = head
    }

    public func becomeSplitOnLastTail(_ value: Text) throws
    {
        let (_, tail) = try self.splitOnLast(value)
        self.text = tail
    }

    public func becomeSplitAtHead(_ index: Int, _ length: Int = 0) throws
    {
        let (head, _) = try self.splitAt(index, length)
        self.text = head
    }

    public func becomeSplitAtTail(_ index: Int, _ length: Int = 0) throws
    {
        let (_, tail) = try self.splitAt(index, length)
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

    public func becomePrepended(_ prefix: Text)
    {
        self.text = self.text.prepend(prefix)
    }

    public func becomeAppended(_ suffix: Text)
    {
        self.text = self.text.append(suffix)
    }
}

// Contains
extension MutableText
{
    public func containsSubstring(_ subtext: Text) -> Bool
    {
        return self.text.containsSubstring(subtext)
    }

    public func startsWith(_ subtext: Text) -> Bool
    {
        return self.text.startsWith(subtext)
    }

    public func containsRegex(_ regex: Regex<AnyRegexOutput>) -> Bool
    {
        return self.text.containsRegex(regex)
    }
}

// Count, IsEmpty
extension MutableText
{
    public func count() -> Int
    {
        return self.text.count()
    }

    public func isEmpty() -> Bool
    {
        return self.text.isEmpty()
    }
}

// Codable to/from JSON
extension MutableText
{
    public convenience init(toJSONFromCodable codable: any Codable) throws
    {
        let text = try Text(toJSONFromCodable: codable)
        self.init(fromText: text)
    }

    public func toCodableFromJSON<T>() throws -> T where T: Codable
    {
        return try self.text.toCodableFromJSON()
    }
}

// Drop
extension MutableText
{
    public func dropFirst() throws -> Text
    {
        return try self.text.dropFirst()
    }

    public func becomeDropFirst() throws
    {
        self.text = try self.text.dropFirst()
    }

    public func dropPrefix(_ text: Text) throws -> Text
    {
        return try self.text.dropPrefix(text)
    }

    public func becomeDropPrefix(_ text: Text) throws
    {
        self.text = try self.text.dropPrefix(text)
    }
}

// Uppercase
extension MutableText
{
    public func uppercase() -> Text
    {
        return self.text.uppercase()
    }

    public func becomeUppercase()
    {
        self.text = self.text.uppercase()
    }

    public func uppercaseFirstLetter() throws -> Text
    {
        return try self.text.uppercaseFirstLetter()
    }

    public func becomeUppercaseFirstLetter() throws
    {
        self.text = try self.text.uppercaseFirstLetter()
    }
}

// Lines
extension MutableText
{
    public func lines(separator: Text? = nil) -> [Text]
    {
        return self.text.lines(separator: separator)
    }
}

// Filter
extension MutableText
{
    public convenience init(unicodeScalarsView: String.UnicodeScalarView)
    {
        self.init(fromText: Text(unicodeScalarsView: unicodeScalarsView))
    }

    public func filter(keep: (Unicode.Scalar) -> Bool) -> Text
    {
        return self.text.filter(keep: keep)
    }
}

// First, Last
extension MutableText
{
    public func first() throws -> Text
    {
        return try self.text.first()
    }

    public func becomFirst() throws
    {
        self.text = try self.text.first()
    }

    public func last() throws -> Text
    {
        return try self.text.last()
    }

    public func becomeLast() throws
    {
        self.text = try self.text.first()
    }
}

// CompactMap
extension MutableText
{
    public func fan() -> [Text]
    {
        return self.text.fan()
    }

    public func compactMap<Y>(_ f: (Text) -> Y?) -> [Y]
    {
        return self.text.compactMap(f)
    }

    public func compactMap<Y>(_ f: (Text) throws -> Y) -> [Y]
    {
        return self.text.compactMap(f)
    }
}

// Reverse
extension MutableText
{
    public func reverse() -> Text
    {
        return self.text.reverse()
    }

    public func becomeReverse()
    {
        self.text = self.text.reverse()
    }
}

public enum MutableTextError: Error
{
    case badIndex(Int)
    case notFound
    case conversionFailed
}
