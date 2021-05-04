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
    StaticConfiguration(kind: kind, provider: CastleTimelineProvider()) { entry in
      CastlesWidgetsEntryView(entry: entry)
    }
    .configurationDisplayName("Highest Attack Castle")
    .description("See the best castle to attack with")
  }
}

struct CastlesWidgetsEntryView : View {
  @Environment(\.widgetFamily) var widgetFamily
  
  var entry: CastleEntry
  
  var body: some View {
    switch widgetFamily {
    case .systemSmall:
      smallView
    case .systemMedium:
      mediumView
    default:
      largeView
    }
  }
  
  private var smallView: some View {
    VStack {
      Image(entry.castle.imageName)
        .resizable()
        .frame(width: 60, height: 80)
      HStack {
        Image(systemName: "suit.heart.fill")
          .foregroundColor(.red)
        Text("\(entry.castle.hp)")
      }
      HStack {
        Image("sword_side")
          .resizable()
          .frame(width: 20, height: 20)
        Text("\(entry.castle.attackPower)")
      }
    }
  }
  
  private var mediumView: some View {
    HStack {
      Image(entry.castle.imageName)
        .resizable()
        .frame(width: 100, height: 130)
      Spacer()
      VStack {
        HStack {
          Image(systemName: "suit.heart.fill")
            .foregroundColor(.red)
          Text("\(entry.castle.hp)")
        }
        HStack {
          Image("sword_side")
            .resizable()
            .frame(width: 20, height: 20)
          Text("\(entry.castle.attackPower)")
        }
      }
      HStack {
        Image("shield")
          .resizable()
          .frame(width: 20, height: 20)
        Text("\(entry.castle.defensePower)")
      }
      Spacer()
    }
    .padding()
  }
  
  private var largeView: some View {
    VStack {
      Text(entry.castle.name)
        .font(.title)
      mediumView
    }
  }
}

struct CastlesWidgets_Previews: PreviewProvider {
  static var previews: some View {
    let castle = Castle(castleID: "0", imageName: "castle1", name: "Castle Swift")
    CastlesWidgetsEntryView(entry: CastleEntry(date: Date(), castle: castle))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
    CastlesWidgetsEntryView(entry: CastleEntry(date: Date(), castle: castle))
      .previewContext(WidgetPreviewContext(family: .systemMedium))
    CastlesWidgetsEntryView(entry: CastleEntry(date: Date(), castle: castle))
      .previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}
