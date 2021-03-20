//
//  CastlesApp.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-16.
//

import SwiftUI

@main
struct CastlesApp: App {
  @StateObject private var viewModel = CastlesAppViewModel()
  
  var body: some Scene {
    WindowGroup {
      DashboardView()
    }
  }
}
