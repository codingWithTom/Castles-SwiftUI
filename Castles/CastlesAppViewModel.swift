//
//  CastlesAppViewModel.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-02-15.
//

import Foundation

final class CastlesAppViewModel {
  struct Dependencies {
    var syncPerkNotificationActions: SyncPerkNotificationActions = SyncPerkNotificationActionsAdapter()
  }
  private let dependencies: Dependencies
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    self.dependencies.syncPerkNotificationActions.execute()
  }
}
