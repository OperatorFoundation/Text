//
//  Text.swift
//  
//
//  Created by Dr. Brandon Wiley on 4/11/23.
//

import Foundation

import Datable
import SwiftHexTools

public struct Text: TextProtocol
{
    public let string: String

    public init()
    {
        self.string = ""
    }

    public init(fromUTF8String: String)
    {
        self.string = fromUTF8String
    }

    public func toUTF8String() -> String
    {
        return self.string
    }
}

// ExpressableByStringLiteral
extension Text: ExpressibleByStringLiteral
{
    public typealias StringLiteralType = String

    public init(stringLiteral value: String)
    {
        self.init(fromUTF8String: value)
    }
}

// Comparable
extension Text: Comparable
{
    public static func < (lhs: Text, rhs: Text) -> Bool
    {
        return lhs.string < rhs.string
    }
}

// Datable
extension Text: MaybeDatable
{
    public init?(data: Data)
    {
        self.init(fromUTF8String: data.string)
    }

    public var data: Data
    {
        return self.string.data
    }
}

// UTF8 Data conversion
extension Text
{
    public init(fromUTF8Data: Data)
    {
        self.init(fromUTF8String: fromUTF8Data.string)
    }

    public func toUTF8Data() -> Data
    {
        return self.string.data
    }
}

// Hex conversion
extension Text
{
    public init(fromHex: Text) throws
    {
        let hexString = fromHex.string
        guard let data = Data(hex: hexString) else
        {
            throw TextError.conversionFailed
        }

        let string = data.string

        self.init(fromUTF8String: string)
    }

    public func toHex() -> Text
    {
        return Text(fromUTF8String: self.string.hexdump)
    }
}

// Base64 conversion
extension Text
{
    public init(fromBase64: Text) throws
    {
        let hexString = fromBase64.string
        guard let data = Data(base64: hexString) else
        {
            throw TextError.conversionFailed
        }

        let string = data.string

        self.init(fromUTF8String: string)
    }

    public func toBase64() -> Text
    {
        return Text(fromUTF8String: self.string.data.base64EncodedString())
    }
}

// Substring
extension Text
{
    public func substring(_ startInclusive: Int, _ endExclusive: Int) throws -> Text
    {
        let startIndex = self.string.index(self.string.startIndex, offsetBy: startInclusive)
        let endIndex = self.string.index(self.string.startIndex, offsetBy: endExclusive)
        let substring = self.string[startIndex..<endIndex]
        let resultString = String(substring)
        return Text(fromUTF8String: resultString)
    }
}

// IndexOf
extension Text
{
    public func indexOf(_ text: Text) throws -> Int
    {
        guard let range = self.string.firstRange(of: text.string) else
        {
            throw TextError.notFound
        }

        let index = range.lowerBound
        return self.string.distance(from: self.string.startIndex, to: index)
    }
}

// Split
extension Text
{
    public func split(_ separator: Text) -> [Text]
    {
        let substrings = self.string.components(separatedBy: separator.string)
        return substrings.map
        {
            substring in

            let string = String(substring)
            return Text(fromUTF8String: string)
        }
    }

    public func splitOn(_ value: Text) throws -> (Text, Text)
    {
        let index = try self.indexOf(value)
        return try self.splitAt(index)
    }

    public func splitAt(_ index: Int) throws -> (Text, Text)
    {
        let splitIndex = self.string.index(self.string.startIndex, offsetBy: index)
        guard splitIndex >= self.string.startIndex, splitIndex < self.string.endIndex else
        {
            throw TextError.badIndex(index)
        }

        let head = String(self.string[self.string.startIndex..<splitIndex])
        let tail = String(self.string[splitIndex..<self.string.endIndex])

        return (Text(fromUTF8String: head), Text(fromUTF8String: tail))
    }
}

// Trim
extension Text
{
    public func trim() -> Text
    {
        let result = self.string.trimmingCharacters(in: .whitespacesAndNewlines)
        return Text(fromUTF8String: result)
    }
}

// Join
extension Text
{
    public func join(_ parts: [Text]) -> Text
    {
        let strings = parts.map { $0.string }
        let result = strings.joined(separator: self.string)
        return Text(fromUTF8String: result)
    }
}

// Prepend, append
extension Text
{
    public func prepend(_ prefix: Text) -> Text
    {
        return prefix.append(self)
    }

    public func append(_ suffix: Text) -> Text
    {
        let result = self.string.appending(suffix.string)
        return Text(fromUTF8String: result)
    }
}

// Contains
extension Text
{
    public func contains(_ subtext: Text) -> Bool
    {
        return self.string.contains(subtext.string)
    }
}

public enum TextError: Error
{
    case badIndex(Int)
    case notFound
    case conversionFailed
}
