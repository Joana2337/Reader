//
//  Item.swift
//  Reader
//  Created by Joanne on 3/3/25.

import Foundation
import SwiftData


import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
