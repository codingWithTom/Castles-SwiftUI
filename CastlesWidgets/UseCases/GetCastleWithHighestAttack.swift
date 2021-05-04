//
//  GetCastleWithHighestAttack.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-05-03.
//

import Foundation

protocol GetCastleWithHighestAttack {
  func execute() -> Castle?
}

final class GetCastleWithHighestAttackAdapter: GetCastleWithHighestAttack {
  struct Dependencies {
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
  }
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> Castle? {
    dependencies.kingdomService.getCastles().min { $0.attackPower > $1.attackPower }
  }
}
