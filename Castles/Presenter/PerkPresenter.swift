//
//  PerkPresenter.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-11.
//

import Foundation

final class PerkPresenter {
  static func viewModel(for perk: Perk) -> ActionViewModel {
    var startDate: Date?
    var endDate: Date?
    let cooldownDate = perk.lastUsedDate.addingTimeInterval(perk.cooldownTime)
    if !perk.isCooldownPassed {
      startDate = perk.lastUsedDate
      endDate = cooldownDate
    }
    switch perk.type {
    case .gold:
      return ActionViewModel(id: perk.id.uuidString, value: "+ \(perk.value)", name: perk.name, imageName: perk.imageName, isIcon: false,
                             effectImageName: "gold", startDate: startDate, endDate: endDate)
    case.attack:
      return ActionViewModel(id: perk.id.uuidString, value: "+ \(perk.value)", name: perk.name, imageName: perk.imageName, isIcon: false,
                             effectImageName: "sword_side", startDate: startDate, endDate: endDate)
    }
  }
}
