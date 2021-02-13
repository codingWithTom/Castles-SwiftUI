//
//  UsePerk.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-11.
//

import Foundation

protocol UsePerk {
  func execute(perk: Perk)
}

final class UsePerkAdapter: UsePerk {
  struct Dependencies {
    var perkService: PerkService = PerkServiceAdapter.shared
    var kingdomService: KingdomService = KingdomServiceAdapter.shared
    var outcomeService: OutcomeService = OutcomeServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute(perk: Perk) {
    dependencies.perkService.use(perk: perk)
    switch perk.type {
    case .gold:
      useGoldPerk(perk)
    case .attack:
      useAttackPerk(perk)
    }
  }
}

private extension UsePerkAdapter {
  func useGoldPerk(_ perk: Perk) {
    do {
      try dependencies.kingdomService.modifyGoldWith(quantity: perk.value)
      dependencies.outcomeService.applyPerkOutcome(.useGoldPerk(goldIncrease: perk.value))
    } catch {
      print("Error increasing gold \(error)")
    }
  }
  
  func useAttackPerk(_ perk: Perk) {
    guard var randomCastle = dependencies.kingdomService.getCastles().randomElement() else { return }
    randomCastle.attackPower += perk.value
    dependencies.kingdomService.updateCastle(randomCastle)
    dependencies.outcomeService.applyPerkOutcome(.useAttackPerk(castle: randomCastle, attackIncrease: perk.value))
  }
}
