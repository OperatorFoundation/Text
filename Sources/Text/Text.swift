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
    static public func join(_ xs: [Text], _ separator: Text? = nil) -> Text
    {
        let strings = xs.map { $0.string }

        let resultString: String
        if let separator
        {
            resultString = strings.joined(separator: separator.string)
        }
        else
        {
            resultString = strings.joined()
        }

        return Text(fromUTF8String: resultString)
    }

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

extension Text: CustomStringConvertible
{
    public var description: String
    {
        return self.string
    }
}

extension Text: LosslessStringConvertible
{
    public init(_ description: String)
    {
        self.init(fromUTF8String: description)
    }
}

extension Text: CustomDebugStringConvertible
{
    public var debugDescription: String
    {
        return self.string
    }
}

extension Text
{
    static public func numeric(_ scalar: UnicodeScalar) -> Bool
    {
        return (scalar.value >= 0x0030) && (scalar.value <= 0x0039) // '0' to '9'
    }
}

// Codable to/from JSON
extension Text
{
    public init(toJSONFromCodable codable: any Codable) throws
    {
        let encoder = JSONEncoder()

        let data = try encoder.encode(codable)
        self.init(fromUTF8Data: data)
    }

    public func toCodableFromJSON<T>() throws -> T where T: Codable
    {
        let data = self.toUTF8Data()

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
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

    @available(iOS 16, macOS 14, *)
    public func substringRegex(_ regex: Regex<AnyRegexOutput>) throws -> Text
    {
        let ranges = self.string.ranges(of: regex)
        guard ranges.count > 0 else
        {
            throw TextError.notFound
        }

        let substring = String(self.string[ranges[0]])
        return Text(fromUTF8String: substring)
    }
}

// IndexOf
extension Text
{
    @available(iOS 16, macOS 14, *)
    public func indexOf(_ text: Text) throws -> Int
    {
        guard let range = self.string.firstRange(of: text.string) else
        {
            throw TextError.notFound
        }

        let index = range.lowerBound
        return self.string.distance(from: self.string.startIndex, to: index)
    }

    @available(iOS 16, macOS 14, *)
    public func lastIndexOf(_ text: Text) throws -> Int
    {
        let ranges = self.string.ranges(of: text.string)

        guard let range = ranges.last else
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

    @available(iOS 16, macOS 14, *)
    public func splitOn(_ value: Text) throws -> (Text, Text)
    {
        let index = try self.indexOf(value)
        return try self.splitAt(index, value.count())
    }

    @available(iOS 16, macOS 14, *)
    public func splitOnLast(_ value: Text) throws -> (Text, Text)
    {
        let index = try self.lastIndexOf(value)
        return try self.splitAt(index, value.count())
    }

    public func splitAt(_ index: Int, _ length: Int = 0) throws -> (Text, Text)
    {
        let headIndex = self.string.index(self.string.startIndex, offsetBy: index)
        guard headIndex >= self.string.startIndex, headIndex <= self.string.endIndex else
        {
            throw TextError.badIndex(index)
        }

        let head = String(self.string[self.string.startIndex..<headIndex])
        let tail = String(self.string[headIndex..<self.string.endIndex])

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

// Contains, StartsWith, EndsWith
extension Text
{
    public func containsSubstring(_ subtext: Text) -> Bool
    {
        return self.string.contains(subtext.string)
    }

    public func startsWith(_ subtext: Text) -> Bool
    {
        guard subtext.count() <= self.count() else
        {
            return false
        }

        do
        {
            let prefix = try self.substring(0, subtext.count())
            return prefix == subtext
        }
        catch
        {
            return false
        }
    }

    public func endsWith(_ subtext: Text) -> Bool
    {
        guard subtext.count() <= self.count() else
        {
            return false
        }

        do
        {
            let suffix = try self.substring(subtext.count(), self.count())
            return suffix == subtext
        }
        catch
        {
            return false
        }
    }

    public func surroundedBy(_ prefix: Text, _ suffix: Text) -> Bool
    {
        return self.startsWith(prefix) && self.endsWith(suffix)
    }

    @available(iOS 16, macOS 14, *)
    public func containsRegex(_ regex: Regex<AnyRegexOutput>) -> Bool
    {
        let ranges = self.string.ranges(of: regex)
        return ranges.count > 0
    }
}

// Count, IsEmpty
extension Text
{
    public func count() -> Int
    {
        return self.string.count
    }

    public func isEmpty() -> Bool
    {
        return self.string.isEmpty
    }
}

// Drop
extension Text
{
    public func dropFirst() throws -> Text
    {
        return try self.substring(1, self.count())
    }

    public func dropLast() throws -> Text
    {
        return try self.substring(0, self.count() - 1)
    }

    public func dropPrefix(_ text: Text) throws -> Text
    {
        guard self.startsWith(text) else
        {
            return self
        }

        let index = text.count()
        let (_, tail) = try self.splitAt(index)
        return tail
    }

    public func dropSuffix(_ text: Text) throws -> Text
    {
        guard self.endsWith(text) else
        {
            return self
        }

        let index = self.count() - text.count()
        let (head, _) = try self.splitAt(index)
        return head
    }

    public func dropSurrounding(_ prefix: Text, _ suffix: Text) throws -> Text
    {
        return try self.dropPrefix(prefix).dropSuffix(suffix)
    }
}

// Uppercase, lowercase
extension Text
{
    public func uppercase() -> Text
    {
        return Text(fromUTF8String: self.string.uppercased())
    }

    public func lowercase() -> Text
    {
        return Text(fromUTF8String: self.string.lowercased())
    }

    public func uppercaseFirstLetter() throws -> Text
    {
        guard self.count() >= 1 else
        {
            throw TextError.textTooShort
        }

        let (head, _) = try self.splitAt(1)
        let tail = try self.dropFirst()
        let capHead = head.uppercase()
        return capHead.append(tail)
    }
}

// Lines
extension Text
{
    public func lines(_ separator: Text? = nil) -> [Text]
    {
        if let separator
        {
            return self.split(separator).map
            {
                text in

                return text.trim()
            }
        }

        if self.string.contains("\r\n")
        {
            return self.lines("\r\n").map
            {
                text in

                return text.trim()
            }
        }

        if self.string.contains("\n\r")
        {
            return self.lines("\n\r").map
            {
                text in

                return text.trim()
            }
        }

        if self.string.contains("\r")
        {
            return self.lines("\r").map
            {
                text in

                return text.trim()
            }
        }

        if self.string.contains("\n")
        {
            return self.lines("\n").map
            {
                text in

                return text.trim()
            }
        }

        return [self]
    }
}

// Filter
extension Text
{
    public init(unicodeScalarsView: String.UnicodeScalarView)
    {
        let string = String(unicodeScalarsView)
        self.init(fromUTF8String: string)
    }

    public func filter(keep: (Unicode.Scalar) -> Bool) -> Text
    {
        let scalars = self.string.unicodeScalars.filter(keep)
        return Text(unicodeScalarsView: scalars)
    }
}

// First, Last
extension Text
{
    public func first() throws -> Text
    {
        guard self.string.count > 0 else
        {
            throw TextError.textTooShort
        }

        return try self.substring(0, 1)
    }

    public func last() throws -> Text
    {
        guard self.string.count > 0 else
        {
            throw TextError.textTooShort
        }

        return try self.substring(self.string.count - 1, self.string.count)
    }
}

// CompactMap
extension Text
{
    public func fan() -> [Text]
    {
        var results: [Text] = []

        for index in 0..<self.count()
        {
            do
            {
                let result = try self.substring(index, index+1)
                results.append(result)
            }
            catch
            {
                continue
            }
        }

        return results
    }

    public func compactMap<Y>(_ f: (Text) -> Y?) -> [Y]
    {
        return self.fan().compactMap(f)
    }

    public func compactMap<Y>(_ f: (Text) throws -> Y) -> [Y]
    {
        return self.fan().compactMap
        {
            (text: Text) -> Y? in

            do
            {
                return try f(text)
            }
            catch
            {
                return nil
            }
        }
    }
}

// Reverse
extension Text
{
    public func reverse() -> Text
    {
        return Text(fromUTF8String: String(self.string.reversed()))
    }
}

public enum TextError: Error
{
    case badIndex(Int)
    case notFound
    case conversionFailed
    case textTooShort
}
