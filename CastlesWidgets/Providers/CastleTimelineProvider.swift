//
//  CastlesWidgets.swift
//  CastlesWidgets
//
//  Created by Tomas Trujillo on 2021-05-02.
//

import WidgetKit
import SwiftUI
import Intents

struct CastleTimelineProvider: IntentTimelineProvider {
  
  func placeholder(in context: Context) -> CastleEntry {
    CastleEntry(date: Date(), castle: Castle(castleID: "0", imageName: "castle1", name: "Swift Castle"))
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CastleEntry) -> ()) {
    let entry = CastleEntry(date: Date(), castle: Castle(castleID: "0", imageName: "castle1", name: "Swift Castle"))
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<CastleEntry>) -> ()) {
    var entries: [CastleEntry] = []
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = CastleEntry(date: entryDate, castle: Castle(castleID: "0", imageName: "castle1", name: "Swift Castle"))
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}
