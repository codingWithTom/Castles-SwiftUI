//
//  StartPerkActivity.swift
//  Castles
//
//  Created by Tomas Trujillo on 2023-10-16.
//

import Foundation
import ActivityKit

protocol StartPerkActivity {
  func execute(_: Perk)
}

final class StartPerkActivityAdapter: StartPerkActivity {
  static var shared: StartPerkActivityAdapter = .init()
  
  private init() { }
  
  func execute(_ perk: Perk) {
    let attributes = PerkAttributes(perk: perk)
    let initialState = PerkAttributes.ContentState(stage: .starting, description: "Your \(perk.name) is charging")
    let content = ActivityContent(state: initialState, staleDate: nil)
    do {
      let activity = try Activity.request(attributes: attributes, content: content)
      ScheduleActivityBGTaskAdapter.shared.execute()
    } catch {
      print("Something happened starting the Activity \(error.localizedDescription)")
    }
  }
}
