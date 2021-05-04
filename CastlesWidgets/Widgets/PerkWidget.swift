//
//  PerkWidget.swift
//  CastlesWidgetsExtension
//
//  Created by Tomas Trujillo on 2021-05-03.
//

import SwiftUI
import WidgetKit

struct PerkEntry: TimelineEntry {
  let date: Date
  let perk: Perk
}

struct PerkWidget: Widget {
  let kind = "Perk Widgets"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: PerkTimelineProvider()) { entry in
      PerkView(entry: entry)
    }
    .supportedFamilies([.systemSmall])
    .configurationDisplayName("Most recent Perk")
    .description("See the perk that closest to finishing its cooldown or ready to use")
  }
}

struct PerkView: View {
  static var timeFormatter: DateComponentsFormatter =  {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .brief
    return formatter
  }()
   
  
  let entry: PerkEntry
  
  @ViewBuilder
  private var timeRemaining: some View {
    let cooldownTime = entry.perk.remainingCooldownTimeFrom(date: entry.date)
    if cooldownTime > 0 {
      Text(entry.perk.cooldownDate, style: .timer)
        .bold()
        .frame(width: 50)
    } else {
      Text("Ready to use!")
        .bold()
    }
  }
  
  var body: some View {
    VStack {
      Image(entry.perk.imageName)
        .resizable()
        .frame(width: 50, height: 50)
      Text(entry.perk.name)
      HStack {
        Spacer()
        timeRemaining
        Spacer()
      }
    }
  }
}

struct PerkWidget_Previews: PreviewProvider {
  static var previews: some View {
    let hourAgo = Date().addingTimeInterval(-3600)
    return PerkView(entry: PerkEntry(date: Date(), perk: .init(name: "Harvest", value: 100, imageName: "plant", type: .gold, cooldownTime: 30, lastUsedDate: hourAgo)))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
