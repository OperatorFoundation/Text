//
//  TextProtocol.swift
//  
//
//  Created by Dr. Brandon Wiley on 4/13/23.
//

import Foundation

import Datable

public protocol TextProtocol:
    Codable,
    Comparable,
    Equatable,
    ExpressibleByStringLiteral,
    Hashable,
    MaybeDatable
{
    static func join(_ xs: [Text], _ seperator: Text?) -> Text

    func toUTF8String() -> String
    func toUTF8Data() -> Data
    func toHex() -> Text
    func toBase64() -> Text
    func substring(_ startInclusive: Int, _ endExclusive: Int) throws -> Text
    func split(_ separator: Text) -> [Text]
    func splitAt(_ index: Int, _ length: Int) throws -> (Text, Text)
    func trim() -> Text
    func join(_ parts: [Text]) -> Text
    func prepend(_ prefix: Text) -> Text
    func append(_ suffix: Text) -> Text
    func containsSubstring(_ subtext: Text) -> Bool
    func startsWith(_ subtext: Text) -> Bool
    func endsWith(_ subtext: Text) -> Bool
    func surroundedBy(_ prefix: Text, _ suffix: Text) -> Bool
    func count() -> Int
    func isEmpty() -> Bool
    func toCodableFromJSON<T>() throws -> T where T: Codable
    func dropFirst() throws -> Text
    func dropLast() throws -> Text
    func dropPrefix(_ text: Text) throws -> Text
    func dropSuffix(_ text: Text) throws -> Text
    func dropSurrounding(_ prefix: Text, _ suffix: Text) throws -> Text
    func uppercase() -> Text
    func lowercase() -> Text
    func uppercaseFirstLetter() throws -> Text
    func lines(_ separator: Text?, _ trim: Bool) -> [Text]
    func filter(keep: (Unicode.Scalar) -> Bool) -> Text
    func first() throws -> Text
    func last() throws -> Text
    func fan() -> [Text]
    func compactMap<Y>(_ f: (Text) -> Y?) -> [Y]
    func compactMap<Y>(_ f: (Text) throws -> Y) -> [Y]
    func reverse() -> Text

    @available(iOS 16, macOS 14, *)
    func substringRegex(_ regex: Regex<AnyRegexOutput>) throws -> Text

    @available(iOS 16, macOS 14, *)
    func containsRegex(_ regex: Regex<AnyRegexOutput>) -> Bool

    @available(iOS 16, macOS 14, *)
    func indexOf(_ text: Text) throws -> Int
    
    @available(iOS 16, macOS 14, *)
    func lastIndexOf(_ text: Text) throws -> Int

    @available(iOS 16, macOS 14, *)
    func splitOn(_ value: Text) throws -> (Text, Text)

    @available(iOS 16, macOS 14, *)
    func splitOnLast(_ value: Text) throws -> (Text, Text)
}
