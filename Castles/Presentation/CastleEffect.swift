//
//  CastleEffect.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-31.
//

import Foundation
import SpriteKit

protocol CastleEffect {
  func effect(for: CastleViewModel.Condition) -> SKNode?
}

final class CastleEffectAdapter: CastleEffect {
  func effect(for condition: CastleViewModel.Condition) -> SKNode? {
    switch condition {
    case .onFire:
      return SKNode(fileNamed: "CastleFire.sks")
    case .perfect:
      return SKNode(fileNamed: "SparklingCastle.sks")
    default:
      return nil
    }
  }
}
