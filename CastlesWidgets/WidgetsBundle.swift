//
//  WidgetsBundle.swift
//  Castles
//
//  Created by Tomas Trujillo on 2021-05-02.
//

import SwiftUI
@main
struct WidgetsBundle: WidgetBundle {
  
  @WidgetBundleBuilder
  var body: some Widget {
    CastlesWidget()
    PerkWidget()
    PerkActivityConfiguration()
  }
}
