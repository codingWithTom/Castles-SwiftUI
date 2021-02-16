//
//  ScheduleNotificationForPerk.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-15.
//

import Foundation
import Combine

protocol ScheduleNotificationForPerk {
  func execute(perk: Perk)
}

final class ScheduleNotificationForPerkAdapter: ScheduleNotificationForPerk {
  struct Dependencies {
    var perkNotificationService: PerkNotificationService = PerkNotificationServiceAdapter.shared
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func execute(perk: Perk) {
    dependencies.perkNotificationService.scheduleNotification(for: perk)
  }
}
