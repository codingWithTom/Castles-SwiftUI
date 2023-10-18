//
//  ScheduleActivityBGTask.swift
//  Castles
//
//  Created by Tomas Trujillo on 2023-10-16.
//

import Foundation
import BackgroundTasks

protocol ScheduleActivityBGTask {
  func execute()
}

final class ScheduleActivityBGTaskAdapter: ScheduleActivityBGTask {
  static var shared: ScheduleActivityBGTaskAdapter = .init()
  
  private init() { }
  
  func execute() {
    let request = BGProcessingTaskRequest(identifier: "PerkUpdate")
    request.earliestBeginDate = Date()
    do {
      try BGTaskScheduler.shared.submit(request)
    } catch {
      print("There was a problem scheduling the background task \(error.localizedDescription)")
    }
  }
}
