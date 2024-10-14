//
//  File.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/11/24.
//

import Foundation

struct Place: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var averageNoise: Float
    var distance: Float
}
