//
//  CastleWidget.swift
//  CastlesWidgetsExtension
//
//  Created by Tomas Trujillo on 2021-05-02.
//

import SwiftUI
import WidgetKit
import Intents

struct CastleEntry: TimelineEntry {
  let date: Date
  let castle: Castle
}

struct CastlesWidget: Widget {
  let kind: String = "CastlesWidgets"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: CastleTimelineProvider()) { entry in
      CastlesWidgetsEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct CastlesWidgetsEntryView : View {
  var entry: CastleEntry
  
  var body: some View {
    Text(entry.date, style: .time)
  }
}

struct CastlesWidgets_Previews: PreviewProvider {
  static var previews: some View {
    let castle = Castle(castleID: "0", imageName: "castle1", name: "Castle Swift")
    CastlesWidgetsEntryView(entry: CastleEntry(date: Date(), castle: castle))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
