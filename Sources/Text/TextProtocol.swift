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
    func indexOf(_ text: Text) throws -> Int
    func split(separator: Text) -> [Text]
    func split(on value: Text) throws -> (Text, Text)
    func split(at index: Int) throws -> (Text, Text)
    func trim() -> Text
    func join(parts: [Text]) -> Text
    func prepend(prefix: Text) -> Text
    func append(suffix: Text) -> Text
}
