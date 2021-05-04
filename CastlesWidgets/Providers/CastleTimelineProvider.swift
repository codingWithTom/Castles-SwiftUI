//
//  CastlesWidgets.swift
//  CastlesWidgets
//
//  Created by Tomas Trujillo on 2021-05-02.
//

import WidgetKit
import SwiftUI
import Intents

struct CastleTimelineProvider: TimelineProvider {
  struct Dependencies {
    var getCastleWithHighestAttack: GetCastleWithHighestAttack = GetCastleWithHighestAttackAdapter()
  }
  
  private let dependencies: Dependencies
  private var sampleCastle: Castle {
    Castle(castleID: "0", imageName: "castle1", name: "Swift Castle")
  }
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
  }
  
  func placeholder(in context: Context) -> CastleEntry {
    CastleEntry(date: Date(), castle: sampleCastle)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (CastleEntry) -> Void) {
    let entry: CastleEntry
    if context.isPreview {
      entry = CastleEntry(date: Date(), castle: sampleCastle)
    } else {
      let highestAttackCastle = dependencies.getCastleWithHighestAttack.execute()
      entry = CastleEntry(date: Date(), castle: highestAttackCastle ?? sampleCastle)
    }
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<CastleEntry>) -> Void) {
    let highestAttackCastle = dependencies.getCastleWithHighestAttack.execute()
    let entry = CastleEntry(date: Date(), castle: highestAttackCastle ?? sampleCastle)
    
    let timeline = Timeline(entries: [entry], policy: .never)
    completion(timeline)
  }
}
