//
//  CastlesApp.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-16.
//

import SwiftUI
import BackgroundTasks

@main
struct CastlesApp: App {
  @StateObject private var viewModel = CastlesAppViewModel()
  
  init() {
    BGTaskScheduler.shared.register(forTaskWithIdentifier: "PerkUpdate", using: nil) { task in
      HandleActivtyUpdateTaskAdapter.shared.execute(task)
    }
  }
  
  var body: some Scene {
    WindowGroup {
      DashboardView()
    }
  }
}
