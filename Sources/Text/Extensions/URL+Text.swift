//
//  URL+Text.swift
//  
//
//  Created by Dr. Brandon Wiley on 4/17/23.
//

import Foundation

public extension URL
{
    func appending(component: Text) -> URL
    {
        return self.appending(component: component.toUTF8String())
    }
}
