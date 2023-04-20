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
    func toUTF8String() -> String
    func toUTF8Data() -> Data
    func toHex() -> Text
    func toBase64() -> Text
    func substring(_ startInclusive: Int, _ endExclusive: Int) throws -> Text
    func substringRegex(_ regex: Regex<AnyRegexOutput>) throws -> Text
    func indexOf(_ text: Text) throws -> Int
    func lastIndexOf(_ text: Text) throws -> Int
    func split(_ separator: Text) -> [Text]
    func splitOn(_ value: Text) throws -> (Text, Text)
    func splitOnLast(_ value: Text) throws -> (Text, Text)
    func splitAt(_ index: Int) throws -> (Text, Text)
    func trim() -> Text
    func join(_ parts: [Text]) -> Text
    func prepend(_ prefix: Text) -> Text
    func append(_ suffix: Text) -> Text
    func containsSubstring(_ subtext: Text) -> Bool
    func startsWith(_ subtext: Text) -> Bool
    func containsRegex(_ regex: Regex<AnyRegexOutput>) -> Bool
    func count() -> Int
    func isEmpty() -> Bool
    func toCodableFromJSON<T>() throws -> T where T: Codable
}
