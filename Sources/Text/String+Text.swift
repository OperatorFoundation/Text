//
//  String+Text.swift
//
//
//  Created by Dr. Brandon Wiley on 12/19/23.
//

import Foundation

extension String
{
    public var text: Text
    {
        return Text(fromUTF8String: self)
    }
}

extension Data
{
    public var text: Text
    {
        return Text(fromUTF8Data: self)
    }
}
