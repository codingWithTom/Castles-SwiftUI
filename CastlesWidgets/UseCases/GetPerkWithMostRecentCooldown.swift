//
//  GetPerkWithMostRecentCooldown.swift
//  CastlesWidgetsExtension
//
//  Created by Tomas Trujillo on 2021-05-03.
//

import Foundation

protocol GetPerkWithMostRecentCooldown {
  func execute() -> Perk?
}

final class GetPerkWithMostRecentCooldownAdapter: GetPerkWithMostRecentCooldown {
  struct Dependencies {
    var perkService: PerkService = PerkServiceAdapter.shared
  }
  
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() -> Perk? {
    dependencies.perkService.getPerks().min { $0.remainingCooldownTime < $1.remainingCooldownTime }
  }
}
