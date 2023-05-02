//
//  SwiftUI.Text+Text.Text.swift
//  
//
//  Created by Dr. Brandon Wiley on 5/2/23.
//

import Foundation
import SwiftUI

public extension SwiftUI.Text
{
    init(_ text: Text)
    {
        self.init(text.toUTF8String())
    }
}
