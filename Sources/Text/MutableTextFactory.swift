//
//  MutableTextFactory.swift
//  
//
//  Created by Dr. Brandon Wiley on 4/13/23.
//

import Foundation

public class MutableTextFactory
{
    public func empty() -> MutableText
    {
        return MutableText()
    }

    public func fromUTF8String(_ value: String) -> MutableText
    {
        return MutableText(fromUTF8String: value)
    }

    public func fromUTF8Data(_ value: Data) throws -> MutableText
    {
        guard let result = MutableText(fromUTF8Data: value) else
        {
            throw MutableTextFactoryError.conversionFailed
        }

        return result
    }

    public func fromText(_ value: Text) -> MutableText
    {
        return MutableText(fromText: value)
    }

    public func fromHex(_ value: Text) throws -> MutableText
    {
        guard let result = MutableText(fromHex: value) else
        {
            throw MutableTextFactoryError.conversionFailed
        }

        return result
    }

    public func fromBase64(_ value: Text) throws -> MutableText
    {
        return try MutableText(fromBase64: value)
    }
}

public enum MutableTextFactoryError: Error
{
    case conversionFailed
}
