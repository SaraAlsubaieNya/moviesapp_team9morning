//
//  Item.swift
//  MoviesApp
//
//  Created by Sara Alsubaie on 23/12/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
