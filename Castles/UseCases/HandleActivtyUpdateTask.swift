//
//  HandleActivtyUpdateTask.swift
//  Castles
//
//  Created by Tomas Trujillo on 2023-10-16.
//

import Foundation
import BackgroundTasks
import ActivityKit

protocol HandleActivtyUpdateTask {
  func execute(_: BGTask)
}

final class HandleActivtyUpdateTaskAdapter: HandleActivtyUpdateTask {
  static var shared: HandleActivtyUpdateTaskAdapter = .init()
  
  private init() { }
  
  func execute(_ task: BGTask) {
    guard let activity = Activity<PerkAttributes>.activities.first else {
      task.setTaskCompleted(success: false)
      return
    }
    let perk = activity.attributes.perk
    let remainingTime = (perk.cooldownTime - perk.remainingCooldownTime) / perk.cooldownTime
    let stage: PerkAttributes.ContentState.Stage
    let description: String
    if remainingTime < 0.33 {
      stage = .starting
      description = "Your \(perk.name) perk is charging"
    } else if remainingTime < 0.66 {
      stage = .middle
      description = "Your \(perk.name) perk is almost charged"
    } else {
      stage = .end
      description = "Your \(perk.name) is charged!!"
    }
    let state = PerkAttributes.ContentState(stage: stage, description: description)
    Task {
      await activity.update(using: state)
      if perk.cooldownDate > Date() {
        ScheduleActivityBGTaskAdapter.shared.execute()
      } else {
        let content = ActivityContent(state: state, staleDate: nil)
        await activity.end(content, dismissalPolicy: .immediate)
      }
      task.setTaskCompleted(success: true)
    }
  }
}
