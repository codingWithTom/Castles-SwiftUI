//
//  SyncPerkNotificationActions.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-15.
//

import Foundation
import Combine

protocol SyncPerkNotificationActions {
  func execute()
}

final class SyncPerkNotificationActionsAdapter: SyncPerkNotificationActions {
  struct Dependencies {
    var perkNotificationService: PerkNotificationService = PerkNotificationServiceAdapter.shared
    var usePerk: UsePerk = UsePerkAdapter()
    var perkService: PerkService = PerkServiceAdapter.shared
  }
  private let dependencies: Dependencies
  private var subscriptions = Set<AnyCancellable>()
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute() {
    dependencies.perkNotificationService.perkActionPublisher.sink { [weak self] perkIdentifier in
      guard let self = self else { return }
      let perks = self.dependencies.perkService.getPerks()
      guard let perk = perks.first(where: { $0.id.uuidString == perkIdentifier }) else { return }
      self.dependencies.usePerk.execute(perk: perk)
    }.store(in: &subscriptions)
  }
}
