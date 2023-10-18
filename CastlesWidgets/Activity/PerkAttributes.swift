//
//  PerkAttributes.swift
//  Castles
//
//  Created by Tomas Trujillo on 2023-10-16.
//

import Foundation
import ActivityKit

struct PerkAttributes: ActivityAttributes {
  let perk: Perk
  
  struct ContentState: Codable, Hashable {
    enum Stage: Int, Codable {
      case starting
      case middle
      case end
    }
    let stage: Stage
    let description: String
  }
}
