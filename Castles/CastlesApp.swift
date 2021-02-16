//
//  CastlesApp.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-01-16.
//

import SwiftUI

@main
struct CastlesApp: App {
  private let viewModel = CastlesAppViewModel()
  
  var body: some Scene {
    WindowGroup {
      DashboardView()
    }
  }
}
