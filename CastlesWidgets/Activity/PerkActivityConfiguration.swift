//
//  PerkActivityConfiguration.swift
//  CastlesWidgetsExtension
//
//  Created by Tomas Trujillo on 2023-10-16.
//

import SwiftUI
import WidgetKit

struct PerkActivityConfiguration: Widget {
    var body: some WidgetConfiguration {
      ActivityConfiguration(for: PerkAttributes.self) { context in
        PerkActivityView(perk: context.attributes.perk, state: context.state)
      } dynamicIsland: { context in
        DynamicIsland {
          DynamicIslandExpandedRegion(.leading) {
            Image(context.attributes.perk.imageName)
              .resizable()
              .scaledToFit()
          }
          DynamicIslandExpandedRegion(.bottom) {
            PerkActivityView(perk: context.attributes.perk, state: context.state)
          }
          DynamicIslandExpandedRegion(.trailing) {
            Image(systemName: context.attributes.perk.iconName)
              .resizable()
              .scaledToFit()
              .tint(.yellow)
          }
        } compactLeading: {
          Image(systemName: context.attributes.perk.iconName)
            .tint(.cyan)
        } compactTrailing: {
          PerkProgressView(stage: context.state.stage)
        } minimal: {
          Image(systemName: context.attributes.perk.iconName)
            .tint(.cyan)
        }
      }
    }
}

struct PerkProgressView: View {
  let stage: PerkAttributes.ContentState.Stage
  
  private var value: Float {
    switch stage {
    case .starting:
      return 0.33
    case .middle:
      return 0.66
    case .end:
      return 1
    }
  }
  
  var body: some View {
    ProgressView(value: value)
      .progressViewStyle(.circular)
      .tint(.orange)
  }
}

struct PerkActivityView: View {
  let perk: Perk
  let state: PerkAttributes.ContentState
  
  var body: some View {
    VStack {
      Text("\(perk.name)")
        .font(.title2)
      Text("\(state.description)")
        .font(.headline)
    }
  }
}
